-- ─── FUNCTION: mail_insertsentmail ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertsentmail(integer, integer, bigint, character varying, character varying, character varying, character varying, character varying, bigint, character varying, character varying, character varying, integer, integer, boolean, boolean, integer, boolean, integer, timestamp without time zone, integer, bigint);
CREATE OR REPLACE FUNCTION public.mail_insertsentmail(
    userno integer,
    reguserno integer,
    boxno bigint,
    fromname character varying,
    fromaddr character varying,
    to character varying,
    cc character varying,
    bcc character varying,
    accno bigint,
    title character varying,
    content character varying,
    priority character varying,
    recipientscount integer,
    readcount integer,
    isonebyone boolean,
    isimportant boolean,
    size integer,
    isfile boolean,
    filecount integer,
    reservedate timestamp without time zone,
    replytype integer,
    originalmailno bigint
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    mailno bigint;
    conversationno bigint;
BEGIN


	INSERT INTO Mail_Mails (
		CMSendNum,
		UserNo, RegUserNo, BoxNo,
		FromName, FromAddr, To, Cc, Bcc,
		ToDomain, AccNo,
		Title, Content, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsDelete, IsImportant, TagNo, ConversationNo,
		TextMode, Size, IsFile, FileCount, RegDate, ReserveDate, ReadDate, EmlFileName)
	VALUES (
		0,
		UserNo, RegUserNo, BoxNo,
		FromName, FromAddr, To, Cc, Bcc,
		'', AccNo,
		Title, Content, 1, 0, Priority, RecipientsCount, ReadCount, IsOneByOne, NULL, NULL, 0, IsImportant, 0, 0,
		2, Size, IsFile, FileCount, NOW(), ReserveDate, NOW(), ''
	)
	

	SET MailNo = lastval()
	
	RETURN QUERY
	SELECT MailNo



	/*
	 * 메일함 메일 개수
	 */
	
	UPDATE Mail_MailBoxs
	SET TotalCount = TotalCount + 1
	WHERE BoxNo = mail_insertsentmail.boxno

	UPDATE Mail_UserSettings
	SET CurrentMailBoxSize = CurrentMailBoxSize + Size
	WHERE UserNo = mail_insertsentmail.userno


	
	
	/*
	 * 대화형 메일 연결 작업
	 */
	 

	SELECT ConversationNo = ConversationNo
	FROM Mail_Mails
	WHERE MailNo = mail_insertsentmail.originalmailno
	
	IF (ConversationNo = 0 AND ReplyType = 2) BEGIN
	
		INSERT INTO Mail_MailConversations (RegUserNo, RegDate, MailCount, Title, Address)
		VALUES (UserNo, NOW(), 2, Title, Addresses)
		
		SET ConversationNo = lastval()
		
		INSERT INTO Mail_MailThreads (MailNo, ConversationNo) VALUES (OriginalMailNo, ConversationNo);
		INSERT INTO Mail_MailThreads (MailNo, ConversationNo) VALUES (MailNo, ConversationNo)
		
	END
	
	ELSE IF (ConversationNo != 0 AND ReplyType = 2) BEGIN
	
		UPDATE Mail_MailConversations SET MailCount = MailCount + 1
		WHERE ConversationNo = ConversationNo
		
		INSERT INTO Mail_MailThreads (MailNo, ConversationNo) VALUES (MailNo, ConversationNo)
	
	END
	
	IF (ReplyType = 2) BEGIN
	
		UPDATE Mail_Mails SET ReplyDate = NOW(), ConversationNo = ConversationNo
		WHERE MailNo = mail_insertsentmail.originalmailno
		
		UPDATE Mail_Mails SET ConversationNo = ConversationNo
		WHERE MailNo = MailNo
	
	END
	
	IF (ReplyType = 3) BEGIN
	
		UPDATE Mail_Mails SET ForwardDate = NOW()
		WHERE MailNo = mail_insertsentmail.originalmailno
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
