-- ─── PROCEDURE→FUNCTION: mail_getmails_bytag ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: dynamic SQL converted best-effort; review EXECUTE statement
DROP FUNCTION IF EXISTS public.mail_getmails_bytag(integer, integer, character varying, bigint, bigint, bigint, integer, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.mail_getmails_bytag(
    IN userno integer,
    IN searchtype integer,
    IN searchtext character varying,
    IN accno bigint,
    IN mailtagno bigint,
    IN quicksearchmode bigint,
    IN sortcolumn integer,
    IN isascending boolean,
    IN countperpage integer,
    IN currentpageindex integer
) RETURNS SETOF record
AS $function$
DECLARE
    query character varying;
    searchresult table (
		rownum		int,
		mailno		bigint
	);
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	/*
	 * 쿼리 조합 시작
	 */

	Query := 'SELECT ROW_NUMBER() OVER (ORDER BY ';
	/*
	 * 정렬 컬럼
	 */
	 
	IF (SortColumn = 1) SET Query += 'FromName + FromAddr ' THEN
	ELSIF (SortColumn = 2) SET Query += 'To ' THEN
	ELSIF (SortColumn = 3) SET Query += 'Title ' THEN
	ELSIF (SortColumn = 4) SET Query += 'MailNo ' THEN
	ELSIF (SortColumn = 5) SET Query += 'Size ' THEN
	ELSIF (SortColumn = 6) SET Query += 'IsImportant ' THEN
	ELSIF (SortColumn = 7) SET Query += 'ReadDate ' THEN
	ELSIF (SortColumn = 8) SET Query += 'IsFile ' THEN

	/*
	 * 정렬 내림차순 여부
	 */
	 
	IF (IsAscending = TRUE) SET Query += 'ASC ' THEN
	ELSE SET Query += 'DESC '		

	IF (SortColumn = 6 OR SortColumn = 7 OR SortColumn = 8) SET Query += ', MailNo DESC ' THEN
	
	
	
	/*
	 * WHERE 조합 시작
	 */
	 
	SET Query += ') RowNum, MailNo FROM Mail_Mails WHERE UserNo = UserNo '


	IF (AccNo = -1) SET Query += 'AND IsDelete = FALSE ' THEN
	ELSE SET Query += 'AND AccNo = AccNo AND IsDelete = FALSE '
	
	SET Query += 'AND TagNo = MailTagNo '


	/*
	 * 빠른 검색 
	 */

	IF (QuickSearchMode = 1) SET Query += '' THEN
	ELSIF (QuickSearchMode = 2) SET Query += 'AND ReadDate IS NOT NULL ' THEN
	ELSIF (QuickSearchMode = 3) SET Query += 'AND ReadDate IS NULL ' THEN
	ELSIF (QuickSearchMode = 4) SET Query += 'AND IsImportant = TRUE ' THEN
	ELSIF (QuickSearchMode = 5) SET Query += 'AND FileCount != 0 ' THEN
	ELSIF (QuickSearchMode >= 20) SET Query += 'AND TagNo = ' || CONVERT(VARCHAR, QuickSearchMode) + ' ' THEN


	/*
	 * 검색 조건
	 */
	 
	IF SearchText != '' THEN

		IF (SearchType = 1) SET Query += 'AND Title ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' ' THEN
		ELSIF (SearchType = 2) SET Query += 'AND To ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' ' THEN
		ELSIF (SearchType = 3) SET Query += 'AND (FromName + FromAddr) ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' ' THEN
		ELSIF (SearchType = 4) SET Query += 'AND RegDate ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' ' THEN

	END IF;

	

	INSERT INTO SearchResult
	EXECUTE format(Query, UserNo, AccNo, MailTagNo, SearchText);
	/*
	 * 
	 */





	TotalItemCount := (SELECT COUNT(*) FROM SearchResult);
	TotalPageCount := TotalItemCount / CountPerPage;
	IF (TotalItemCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1 THEN
	IF (TotalPageCount = 0) SET TotalPageCount = 1 THEN
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount THEN

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := mail_getmails_bytag.currentpageindex * CountPerPage;
	RETURN QUERY
	SELECT M.MailNo, CMSendNum, M.RegUserNo, MB.BoxNo, FromName, FromAddr, To, Cc, Bcc,
		AccNo, Title, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo,
		Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate, 		case 
		when MB.SortNo = 1 and MB.ParentNo = -1 then '전체메일함'
		when MB.SortNo = 2 and MB.ParentNo = -1 then '받은메일함'
		when MB.SortNo = 3 and MB.ParentNo = -1 then '보낸메일함'
		when MB.SortNo = 4 and MB.ParentNo = -1 then '임시보관함'
		when MB.SortNo = 5 and MB.ParentNo = -1 then '스팸메일함'
		when MB.SortNo = 6 and MB.ParentNo = -1 then '휴지통'
		when MB.SortNo = 7 and MB.ParentNo = -1 then '읽지않은메일함'
		when MB.SortNo = 8 and MB.ParentNo = -1 then '예약메일함'
		ELSE
		MB.Name end AS BoxName
	FROM SearchResult T
	INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
	INNER JOIN Mail_MailBoxs MB ON MB.BoxNo = M.BoxNo
	LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_bytag.userno) MT ON MT.TagNo = M.TagNo
	WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum
	ORDER BY T.RowNum ASC
	
	RETURN QUERY
	SELECT TotalItemCount AS TotalMailCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
