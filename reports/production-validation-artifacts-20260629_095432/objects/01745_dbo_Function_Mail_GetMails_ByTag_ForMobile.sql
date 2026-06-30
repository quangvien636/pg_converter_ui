-- ─── FUNCTION: mail_getmails_bytag_formobile ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmails_bytag_formobile(integer, integer, character varying, bigint, bigint, bigint, integer, boolean, boolean, bigint, integer);
CREATE OR REPLACE FUNCTION public.mail_getmails_bytag_formobile(
    userno integer,
    searchtype integer,
    searchtext character varying,
    accno bigint,
    mailtagno bigint,
    quicksearchmode bigint,
    sortcolumn integer,
    isascending boolean,
    isdownward boolean,
    anchormailno bigint,
    readcount integer
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
    anchorrownum bigint;
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
	 
	SET Query += ') RowNum, MailNo FROM Mail_Mails WHERE UserNo = UserNo '


	IF (AccNo = -1) SET Query += 'AND IsDelete = FALSE '
	ELSE SET Query += 'AND AccNo = AccNo AND IsDelete = FALSE '
	
	SET Query += 'AND TagNo = MailTagNo '



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
		'UserNo AS INT, AccNo AS BIGINT, MailTagNo AS BIGINT, SearchText AS NVARCHAR(100)',
		UserNo, AccNo, MailTagNo, SearchText
		
	/*
	 * 메일 목록을 가져옵니다.
	 */
	 

	SET AnchorRowNum = 0

	IF (AnchorMailNo != 0 ) BEGIN

		SELECT AnchorRowNum = RowNum FROM SearchResult WHERE MailNo = mail_getmails_bytag_formobile.anchormailno
		
	END
	

	IF (IsDownward = TRUE) BEGIN
	
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
	
	END
	
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
