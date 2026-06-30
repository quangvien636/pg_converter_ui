-- ─── FUNCTION: mail_getmails_forscrollpaging ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmails_forscrollpaging(integer, integer, character varying, bigint, bigint, bigint, integer, boolean, bigint);
CREATE OR REPLACE FUNCTION public.mail_getmails_forscrollpaging(
    userno integer,
    searchtype integer,
    searchtext character varying,
    accno bigint,
    boxno bigint,
    parentno bigint,
    sortno integer,
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
		rownum	bigint,
		mailno	bigint
	);
    anchorrownum bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	/*
	 * 쿼리 조합 시작
	 */
	 

	SET Query =
		'SELECT ROW_NUMBER() OVER (ORDER BY COALESCE(ReserveDate, RegDate) DESC) RowNum, MailNo ' +
		'FROM Mail_Mails WHERE UserNo = UserNo '



	/*
	 * 전체메일함 여부 확인
	 */

	IF (ParentNo = -1 AND SortNo = 1) BEGIN

		SET Query = (
			'DECLARE ExcludedMailboxes TABLE ( BoxNo BIGINT )' +
			'INSERT INTO ExcludedMailboxes ' +
			'SELECT BoxNo FROM public."Mail_GetMailBoxs_ForAllBox"(UserNo) '
			) + Query

		SET Query += 'AND BoxNo IN (SELECT * FROM ExcludedMailboxes) '
		
	END

	ELSE IF (ParentNo = -1 AND SortNo = 7) BEGIN

		SET Query = (
			'DECLARE ExcludedMailboxes TABLE ( BoxNo BIGINT )' +
			'INSERT INTO ExcludedMailboxes ' +
			'SELECT BoxNo FROM public."Mail_GetMailBoxs_ForAllBox"(UserNo) '
			) + Query

		SET Query += 'AND BoxNo IN (SELECT * FROM ExcludedMailboxes) AND ReadDate IS NULL '
		
	END

	ELSE BEGIN

		SET Query += 'AND BoxNo = BoxNo '
		
	END

	IF (AccNo = -1) SET Query += 'AND IsDelete = FALSE '
	ELSE SET Query += 'AND AccNo = AccNo AND IsDelete = FALSE '



	/*
	 * 검색 조건
	 */
	 
	IF (SearchText != '') BEGIN

		IF (SearchType = 1) SET Query += 'AND Title ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
		ELSE IF (SearchType = 2) SET Query += 'AND (To + Cc + Bcc) ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
		ELSE IF (SearchType = 3) SET Query += 'AND (FromName + FromAddr) ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
		ELSE IF (SearchType = 4) SET Query += 'AND RegDate ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
		ELSE IF (SearchType = 6) SET Query += 'AND To ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
		ELSE IF (SearchType = 7) SET Query += 'AND Cc ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
		ELSE IF (SearchType = 8) SET Query += 'AND Bcc ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '

	END



	INSERT INTO SearchResult
	EXEC SP_EXECUTESQL Query,
		'UserNo AS INT, BoxNo AS BIGINT, AccNo AS BIGINT, SearchText AS NVARCHAR(100)',
		UserNo, BoxNo, AccNo, SearchText
		

    /*
     * 메일 목록을 가져옵니다.
     */
     

	SET AnchorRowNum = 0

	IF (AnchorMailNo != 0 ) BEGIN

		SELECT AnchorRowNum = RowNum FROM SearchResult WHERE MailNo = mail_getmails_forscrollpaging.anchormailno
		
	END

	IF (IsDownward = TRUE) BEGIN

		IF (ParentNo = -1 AND SortNo = 1) BEGIN

			RETURN QUERY
			SELECT /* TOP 20 */ M.MailNo, CMSendNum, M.RegUserNo, MB.BoxNo, FromName, FromAddr, To, Cc, Bcc,
				AccNo, Title, Content, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
				Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate, MB.Name AS BoxName
			FROM SearchResult T
			INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
			INNER JOIN Mail_MailBoxs MB ON MB.BoxNo = M.BoxNo
			LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_forscrollpaging.userno) MT ON MT.TagNo = M.TagNo
			WHERE T.RowNum > AnchorRowNum
			ORDER BY T.RowNum ASC
		
		END
		
		ELSE BEGIN
		
			RETURN QUERY
			SELECT /* TOP 20 */ M.MailNo, CMSendNum, M.RegUserNo, BoxNo, FromName, FromAddr, To, Cc, Bcc,
				AccNo, Title, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
				Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate
			FROM SearchResult T
			INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
			LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_forscrollpaging.userno) MT ON MT.TagNo = M.TagNo
			WHERE T.RowNum > AnchorRowNum
			ORDER BY T.RowNum ASC
		
		END
		
	END

	ELSE BEGIN

		IF (ParentNo = -1 AND SortNo = 1) BEGIN
		
			RETURN QUERY
			SELECT M.MailNo, CMSendNum, M.RegUserNo, MB.BoxNo, FromName, FromAddr, To, Cc, Bcc,
				AccNo, Title, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
				Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate, MB.Name AS BoxName
			FROM SearchResult T
			INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
			INNER JOIN Mail_MailBoxs MB ON MB.BoxNo = M.BoxNo
			LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_forscrollpaging.userno) MT ON MT.TagNo = M.TagNo
			WHERE T.RowNum < AnchorRowNum
			ORDER BY T.RowNum ASC

		END
		
		ELSE BEGIN
		
			RETURN QUERY
			SELECT M.MailNo, CMSendNum, M.RegUserNo, BoxNo, FromName, FromAddr, To, Cc, Bcc,
				AccNo, Title, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
				Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate
			FROM SearchResult T
			INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
			LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_forscrollpaging.userno) MT ON MT.TagNo = M.TagNo
			WHERE T.RowNum < AnchorRowNum
			ORDER BY T.RowNum ASC
			
		END

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
