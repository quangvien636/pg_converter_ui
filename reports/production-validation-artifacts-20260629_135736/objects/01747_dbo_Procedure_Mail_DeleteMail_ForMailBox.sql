-- ─── PROCEDURE→FUNCTION: mail_deletemail_formailbox ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_deletemail_formailbox(integer, bigint);
CREATE OR REPLACE FUNCTION public.mail_deletemail_formailbox(
    IN userno integer,
    IN boxno bigint
) RETURNS void
AS $function$
DECLARE
    listoftags table (
		tagno		bigint,
		totalcount	int,
		unreadcount	int
	);
    allboxs table (
		boxno	bigint
	);
    listofsendnums table (
		cmsendnum	bigint
	);
    listofmails table (
		mailno			bigint,
		conversationno	bigint,
		size			int
	);
BEGIN

		
	-- 태그별 메일 개수를 조정합니다.

	INSERT INTO ListOfTags
	SELECT TagNo, COUNT(*) AS TotalCount, SUM(CASE WHEN ReadDate IS NULL THEN 1 ELSE 0 END) AS UnReadCount
	FROM Mail_Mails
	WHERE BoxNo = mail_deletemail_formailbox.boxno AND IsDelete = FALSE AND TagNo != 0 
	GROUP BY TagNo

	UPDATE Mail_MailTags SET
		TotalCount = TotalCount - (SELECT TotalCount FROM ListOfTags WHERE TagNo = Mail_MailTags.TagNo),
		UnReadCount = UnReadCount - (SELECT UnReadCount FROM ListOfTags WHERE TagNo = Mail_MailTags.TagNo)
	WHERE TagNo IN (SELECT TagNo FROM ListOfTags)


	-- 현재, 전체 메일함의 메일 개수를 조정합니다.

	INSERT INTO AllBoxs
	SELECT BoxNo FROM public."Mail_GetMailBoxs_ForAllBox"(UserNo)

	IF (SELECT COUNT(*) FROM AllBoxs WHERE BoxNo = mail_deletemail_formailbox.boxno) > 0 THEN


		SELECT TotalCount, UnReadCount INTO totalcount, unreadcount FROM Mail_MailBoxs WHERE BoxNo = mail_deletemail_formailbox.boxno

		UPDATE Mail_MailBoxs SET TotalCount = TotalCount - TotalCount, UnReadCount = UnReadCount - UnReadCount
		WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_deletemail_formailbox.userno AND ParentNo = -1 AND SortNo = 1)

	END IF;

	UPDATE Mail_MailBoxs SET TotalCount = 0, UnReadCount = 0 WHERE BoxNo = mail_deletemail_formailbox.boxno


	-- 예약 메일을 취소합니다.

	INSERT INTO ListOfSendNums
	SELECT CMSendNum FROM Mail_Mails WHERE BoxNo = mail_deletemail_formailbox.boxno AND IsDelete = FALSE AND ReserveDate IS NOT NULL AND ReserveDate > NOW()

	UPDATE Mail_SentLogs SET IsCancel = TRUE WHERE CMSendNum IN (SELECT CMSendNum FROM ListOfSendNums);
	UPDATE CrewCloud_MailCenter.public."CMsend" SET RD = 'O' WHERE Num IN (SELECT CMSendNum FROM ListOfSendNums)


	-- 메일 대화 이력을 삭제합니다.

	INSERT INTO ListOfMails
	SELECT MailNo, ConversationNo, Size FROM Mail_Mails WHERE BoxNo = mail_deletemail_formailbox.boxno AND IsDelete = FALSE

	DELETE FROM Mail_MailThreads WHERE MailNo IN (SELECT MailNo FROM ListOfMails);
	UPDATE Mail_MailConversations SET MailCount = MailCount - 1 WHERE ConversationNo IN (SELECT ConversationNo FROM ListOfMails)


	-- 사용 용량을 조정합니다.;
	UPDATE Mail_UserSettings SET CurrentMailBoxSize = COALESCE(CurrentMailBoxSize, 0) - COALESCE((SELECT SUM(Convert(bigint,Size)) FROM ListOfMails), 0) WHERE UserNo = mail_deletemail_formailbox.userno


	-- 지정된 메일함의 모든 메일들을 삭제합니다.;
	UPDATE Mail_Mails SET IsDelete = TRUE, TagNo = 0 WHERE MailNo IN (SELECT MailNo FROM ListOfMails);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
