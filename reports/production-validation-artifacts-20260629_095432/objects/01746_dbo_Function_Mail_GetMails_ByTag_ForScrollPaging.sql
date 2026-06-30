-- ─── FUNCTION: mail_getmails_bytag_forscrollpaging ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmails_bytag_forscrollpaging(integer, integer, character varying, bigint, bigint, boolean, bigint);
CREATE OR REPLACE FUNCTION public.mail_getmails_bytag_forscrollpaging(
    userno integer,
    searchtype integer,
    searchtext character varying,
    accno bigint,
    mailtagno bigint,
    isdownward boolean,
    anchormailno bigint
) RETURNS TABLE(
    tagno text,
    imageno text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
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

	SET Query =
		'SELECT ROW_NUMBER() OVER (ORDER BY MailNo DESC) RowNum, MailNo ' +
		'FROM Mail_Mails WHERE UserNo = UserNo '

	IF (AccNo = -1) SET Query += 'AND IsDelete = FALSE '
	ELSE SET Query += 'AND AccNo = AccNo AND IsDelete = FALSE '
	
	SET Query += 'AND TagNo = MailTagNo '



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

		SELECT AnchorRowNum = RowNum FROM SearchResult WHERE MailNo = mail_getmails_bytag_forscrollpaging.anchormailno
		
	END
	

	IF (IsDownward = TRUE) BEGIN
	
		RETURN QUERY
		SELECT /* TOP 20 */ M.MailNo, CMSendNum, M.RegUserNo, MB.BoxNo, FromName, FromAddr, To, Cc, Bcc,
			AccNo, Title, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo,
			Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate, MB.Name AS BoxName
		FROM SearchResult T
		INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
		INNER JOIN Mail_MailBoxs MB ON MB.BoxNo = M.BoxNo
		LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_bytag_forscrollpaging.userno) MT ON MT.TagNo = M.TagNo
		WHERE T.RowNum > AnchorRowNum
		ORDER BY T.RowNum ASC
	
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT M.MailNo, CMSendNum, M.RegUserNo, MB.BoxNo, FromName, FromAddr, To, Cc, Bcc,
			AccNo, Title, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo,
			Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate, MB.Name AS BoxName
		FROM SearchResult T
		INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
		INNER JOIN Mail_MailBoxs MB ON MB.BoxNo = M.BoxNo
		LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_bytag_forscrollpaging.userno) MT ON MT.TagNo = M.TagNo
		WHERE T.RowNum < AnchorRowNum
		ORDER BY T.RowNum ASC
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
