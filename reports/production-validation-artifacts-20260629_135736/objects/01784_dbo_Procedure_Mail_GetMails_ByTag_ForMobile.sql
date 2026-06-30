-- ─── PROCEDURE→FUNCTION: mail_getmails_bytag_formobile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: dynamic SQL converted best-effort; review EXECUTE statement
DROP FUNCTION IF EXISTS public.mail_getmails_bytag_formobile(integer, integer, character varying, bigint, bigint, bigint, integer, boolean, boolean, bigint, integer);
CREATE OR REPLACE FUNCTION public.mail_getmails_bytag_formobile(
    IN userno integer,
    IN searchtype integer,
    IN searchtext character varying,
    IN accno bigint,
    IN mailtagno bigint,
    IN quicksearchmode bigint,
    IN sortcolumn integer,
    IN isascending boolean,
    IN isdownward boolean,
    IN anchormailno bigint,
    IN readcount integer
) RETURNS SETOF record
AS $function$
DECLARE
    query character varying;
    searchresult table (
		rownum		int,
		mailno		bigint
	);
    anchorrownum bigint;
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
	 * 메일 목록을 가져옵니다.
	 */
	 

	AnchorRowNum := 0;
	IF AnchorMailNo != 0 THEN

		SELECT RowNum INTO anchorrownum FROM SearchResult WHERE MailNo = mail_getmails_bytag_formobile.anchormailno
		
	END IF;
	

	IF IsDownward = TRUE THEN
	
		RETURN QUERY
		SELECT TOP (ReadCount) M.MailNo, CMSendNum, M.RegUserNo, MB.BoxNo, FromName, FromAddr, To, Cc, Bcc,
			AccNo, Title, SUBSTRING(Content,0, 300) AS Content, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo,
			Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate, MB.Name AS BoxName
		FROM SearchResult T
		INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
		INNER JOIN Mail_MailBoxs MB ON MB.BoxNo = M.BoxNo
		LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_bytag_formobile.userno) MT ON MT.TagNo = M.TagNo
		WHERE T.RowNum > AnchorRowNum
		ORDER BY T.RowNum ASC
	
	END IF;
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT M.MailNo, CMSendNum, M.RegUserNo, MB.BoxNo, FromName, FromAddr, To, Cc, Bcc,
			AccNo, Title, SUBSTRING(Content,0, 300) AS Content, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo,
			Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate, MB.Name AS BoxName
		FROM SearchResult T
		INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
		INNER JOIN Mail_MailBoxs MB ON MB.BoxNo = M.BoxNo
		LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_bytag_formobile.userno) MT ON MT.TagNo = M.TagNo
		WHERE T.RowNum < AnchorRowNum
		ORDER BY T.RowNum ASC
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
