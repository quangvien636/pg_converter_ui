-- ─── FUNCTION: mail_deletemail ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_deletemail(bigint);
CREATE OR REPLACE FUNCTION public.mail_deletemail(
    mailno bigint
) RETURNS void
AS $function$
DECLARE
    cmsendnum bigint;
    userno integer;
    boxno bigint;
    tagno bigint;
    conversationno bigint;
    mailsize integer;
    reservedate timestamp without time zone;
    readdate timestamp without time zone;
    allboxs table (
		boxno	bigint
	);
BEGIN










	SELECT
		CMSendNum = CMSendNum,
		UserNo = UserNo,
		BoxNo = BoxNo,
		TagNo = TagNo,
		ConversationNo = ConversationNo,
		MailSize = Size,
		ReserveDate = ReserveDate,
		ReadDate = ReadDate
	FROM Mail_Mails WHERE MailNo = mail_deletemail.mailno


	-- 태그별 메일 개수를 조정합니다.
	IF (TagNo != 0) BEGIN

		IF (ReadDate IS NULL) BEGIN
		
			UPDATE Mail_MailTags SET TotalCount = TotalCount - 1, UnReadCount = UnReadCount - 1 WHERE TagNo = TagNo

		END

		ELSE BEGIN

			UPDATE Mail_MailTags SET TotalCount = TotalCount - 1 WHERE TagNo = TagNo

		END

	END

	-- 메일을 삭제합니다.;
	UPDATE Mail_Mails SET IsDelete = TRUE, TagNo = 0 WHERE MailNo = mail_deletemail.mailno

	-- 현재, 전체 메일함의 메일 개수를 조정합니다.

	INSERT INTO AllBoxs
	SELECT BoxNo FROM public."Mail_GetMailBoxs_ForAllBox"(UserNo)

	IF (ReadDate IS NULL) BEGIN
	
		UPDATE Mail_MailBoxs SET TotalCount = TotalCount - 1, UnReadCount = UnReadCount - 1 WHERE BoxNo = BoxNo

		IF ((SELECT COUNT(*) FROM AllBoxs WHERE BoxNo = BoxNo) > 0) BEGIN

			UPDATE Mail_MailBoxs SET TotalCount = TotalCount - 1, UnReadCount = UnReadCount - 1
			WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = UserNo AND ParentNo = -1 AND SortNo = 1)

		END

	END

	ELSE BEGIN

		UPDATE Mail_MailBoxs SET TotalCount = TotalCount - 1 WHERE BoxNo = BoxNo

		IF ((SELECT COUNT(*) FROM AllBoxs WHERE BoxNo = BoxNo) > 0) BEGIN

			UPDATE Mail_MailBoxs SET TotalCount = TotalCount - 1
			WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = UserNo AND ParentNo = -1 AND SortNo = 1)

		END

	END


	-- 예약 메일을 취소합니다.
	IF (ReserveDate IS NOT NULL) BEGIN
	
		IF (ReserveDate > NOW()) BEGIN
		
			UPDATE Mail_SentLogs SET IsCancel = TRUE WHERE CMSendNum = CMSendNum;
			UPDATE CrewCloud_MailCenter.public."CMsend" SET RD = 'O' WHERE Num = CMSendNum
			
		END
	
	END


	-- 메일 대화 이력을 삭제합니다.;
	DELETE FROM Mail_MailThreads WHERE MailNo = mail_deletemail.mailno;
	UPDATE Mail_MailConversations SET MailCount = MailCount - 1 WHERE ConversationNo = ConversationNo


	-- 사용 용량을 조정합니다.;
	UPDATE Mail_UserSettings SET CurrentMailBoxSize = CurrentMailBoxSize - MailSize WHERE UserNo = UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
