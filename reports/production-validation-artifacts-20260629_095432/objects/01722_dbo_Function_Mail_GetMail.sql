-- ─── FUNCTION: mail_getmail ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmail(integer, bigint);
CREATE OR REPLACE FUNCTION public.mail_getmail(
    userno integer,
    mailno bigint
) RETURNS TABLE(
    tagno text,
    imageno text
)
AS $function$
DECLARE
    _userno integer;
    readdate timestamp without time zone;
    currentdatetime timestamp without time zone;
BEGIN


	/*
	 * 메일 정보를 가져옵니다.
	 */
	 


	SELECT _UserNo = mail_getmail.userno, ReadDate = ReadDate FROM Mail_Mails WHERE MailNo = mail_getmail.mailno
	
	
	
	/*
	 * 메일 상세 정보를 반환합니다.
	 */
	
	IF (ReadDate IS NULL AND _UserNo = mail_getmail.userno) BEGIN
		

		SET CurrentDateTime = NOW()
		
		EXEC Mail_UpdateMail_ReadDate _UserNo, MailNo, CurrentDateTime
		
		RETURN QUERY
		SELECT MailNo, CMSendNum, UserNo, RegUserNo, BoxNo, FromName, FromAddr, To, Cc, Bcc, ToDomain, AccNo, Title, Content,
			IsSent, IsCalendar, Priority, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
			Size, IsFile, FileCount, RegDate, ReserveDate, ReadDate, EmlFileName,
			TRUE AS IsCurrentRead,IsDelete
		FROM Mail_Mails M
		LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = _UserNo) MT ON MT.TagNo = M.TagNo
		WHERE MailNo = mail_getmail.mailno
	
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT MailNo, CMSendNum, UserNo, RegUserNo, BoxNo, FromName, FromAddr, To, Cc, Bcc, ToDomain, AccNo, Title, Content,
			IsSent, IsCalendar, Priority, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
			Size, IsFile, FileCount, RegDate, ReserveDate, ReadDate, EmlFileName,
			FALSE AS IsCurrentRead,IsDelete
		FROM Mail_Mails M
		LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = _UserNo) MT ON MT.TagNo = M.TagNo
		WHERE MailNo = mail_getmail.mailno
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
