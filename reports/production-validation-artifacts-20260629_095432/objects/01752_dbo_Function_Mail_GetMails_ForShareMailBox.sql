-- ─── FUNCTION: mail_getmails_forsharemailbox ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmails_forsharemailbox(integer, integer, character varying, bigint, bigint, integer, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.mail_getmails_forsharemailbox(
    userno integer,
    searchtype integer,
    searchtext character varying,
    boxno bigint,
    quicksearchmode bigint,
    sortcolumn integer,
    isascending boolean,
    countperpage integer,
    currentpageindex integer
) RETURNS TABLE(
    tagno text,
    imageno text
)
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
BEGIN

	
	/*
	 * 쿼리 조합 시작
	 */

	SET Query = 'SELECT ROW_NUMBER() OVER (ORDER BY '


	/*
	 * 정렬 컬럼
	 */
	 
	IF (SortColumn = 1) SET Query += 'FromName + FromAddr '
	ELSE IF (SortColumn = 2) SET Query += 'To '
	ELSE IF (SortColumn = 3) SET Query += 'Title '
	ELSE IF (SortColumn = 4) SET Query += 'MailNo '
	ELSE IF (SortColumn = 5) SET Query += 'Size '
	ELSE IF (SortColumn = 6) SET Query += 'IsImportant '
	ELSE IF (SortColumn = 7) SET Query += 'ReadDate '
	ELSE IF (SortColumn = 8) SET Query += 'IsFile '


	/*
	 * 정렬 내림차순 여부
	 */
	 
	IF (IsAscending = TRUE) SET Query += 'ASC '
	ELSE SET Query += 'DESC '

	IF (SortColumn = 6 OR SortColumn = 7 OR SortColumn = 8) SET Query += ', MailNo DESC '

	/*
	 * WHERE 조합 시작
	 */
	 
	SET Query += ') RowNum, MailNo FROM Mail_Mails WHERE UserNo = UserNo AND BoxNo = BoxNo AND IsDelete = FALSE'



	/*
	 * 빠른 검색 
	 */

	IF (QuickSearchMode = 1) SET Query += ''
	ELSE IF (QuickSearchMode = 2) SET Query += 'AND ReadDate IS NOT NULL '
	ELSE IF (QuickSearchMode = 3) SET Query += 'AND ReadDate IS NULL '
	ELSE IF (QuickSearchMode = 4) SET Query += 'AND IsImportant = TRUE '
	ELSE IF (QuickSearchMode = 5) SET Query += 'AND FileCount != 0 '
	ELSE IF (QuickSearchMode >= 20) SET Query += 'AND TagNo = ' || CONVERT(VARCHAR, QuickSearchMode) + ' '


	/*
	 * 검색 조건
	 */
	 
	IF (SearchText != '') BEGIN

		IF (SearchType = 1) SET Query += 'AND Title ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
		ELSE IF (SearchType = 2) SET Query += 'AND To ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
		ELSE IF (SearchType = 3) SET Query += 'AND (FromName + FromAddr) ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
		ELSE IF (SearchType = 4) SET Query += 'AND RegDate ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '

	END

	

	INSERT INTO SearchResult
	EXEC SP_EXECUTESQL Query,
		'UserNo AS INT, BoxNo AS BIGINT, SearchText AS NVARCHAR(100)',
		UserNo, BoxNo, SearchText
	
	/*
	 * 
	 */





	SET TotalItemCount = (SELECT COUNT(*) FROM SearchResult)
	SET TotalPageCount = TotalItemCount / CountPerPage
	
	IF (TotalItemCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	SET EndRowNum = mail_getmails_forsharemailbox.currentpageindex * CountPerPage

	RETURN QUERY
	SELECT M.MailNo, CMSendNum, M.RegUserNo, BoxNo, FromName, FromAddr, To, Cc, Bcc,
		AccNo, Title, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo,
		Size, IsFile, FileCount, RegDate, ReserveDate, '2014-01-01' AS ReadDate
	FROM SearchResult T
	INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
	LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_forsharemailbox.userno) MT ON MT.TagNo = M.TagNo
	WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum
	ORDER BY T.RowNum ASC
	
	RETURN QUERY
	SELECT TotalItemCount AS TotalMailCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
