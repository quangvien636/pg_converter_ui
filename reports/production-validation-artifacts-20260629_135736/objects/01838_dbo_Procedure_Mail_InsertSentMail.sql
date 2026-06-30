-- ─── PROCEDURE→FUNCTION: mail_insertsentmail ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_insertsentmail(integer, integer, bigint, character varying, character varying, character varying, character varying, character varying, bigint, character varying, character varying, character varying, integer, integer, boolean, boolean, integer, boolean, integer, timestamp without time zone, integer, bigint);
CREATE OR REPLACE FUNCTION public.mail_insertsentmail(
    IN userno integer,
    IN reguserno integer,
    IN boxno bigint,
    IN fromname character varying,
    IN fromaddr character varying,
    IN to character varying,
    IN cc character varying,
    IN bcc character varying,
    IN accno bigint,
    IN title character varying,
    IN content character varying,
    IN priority character varying,
    IN recipientscount integer,
    IN readcount integer,
    IN isonebyone boolean,
    IN isimportant boolean,
    IN size integer,
    IN isfile boolean,
    IN filecount integer,
    IN reservedate timestamp without time zone,
    IN replytype integer,
    IN originalmailno bigint
) RETURNS SETOF record
AS $function$
DECLARE
    mailno bigint;
    conversationno bigint;
-- !! WARNING: output needs manual review — see TODO comments
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
	

	MailNo := lastval();
	RETURN QUERY
	SELECT MailNo



	/*
	 * 메일함 메일 개수
	 */
	
	UPDATE Mail_MailBoxs
	TotalCount := TotalCount + 1;
	WHERE BoxNo = mail_insertsentmail.boxno

	UPDATE Mail_UserSettings
	CurrentMailBoxSize := CurrentMailBoxSize + Size;
	WHERE UserNo = mail_insertsentmail.userno


	
	
	/*
	 * 대화형 메일 연결 작업
	 */
	 

	SELECT  INTO  FROM Mail_Mails
	WHERE MailNo = mail_insertsentmail.originalmailno
	
	IF ConversationNo = 0 AND ReplyType = 2 THEN
	
		INSERT INTO Mail_MailConversations (RegUserNo, RegDate, MailCount, Title, Address)
		VALUES (UserNo, NOW(), 2, Title, Addresses)
		
		ConversationNo := lastval();;
		INSERT INTO Mail_MailThreads (MailNo, ConversationNo) VALUES (OriginalMailNo, ConversationNo);
		INSERT INTO Mail_MailThreads (MailNo, ConversationNo) VALUES (MailNo, ConversationNo)
		
	END IF;
	
	ELSIF ConversationNo != 0 AND ReplyType = 2 THEN
	
		UPDATE Mail_MailConversations SET MailCount = MailCount + 1
		WHERE ConversationNo = ConversationNo
		
		INSERT INTO Mail_MailThreads (MailNo, ConversationNo) VALUES (MailNo, ConversationNo)
	
	END IF;
	
	IF ReplyType = 2 THEN
	
		UPDATE Mail_Mails SET ReplyDate = NOW(), ConversationNo = ConversationNo
		WHERE MailNo = mail_insertsentmail.originalmailno
		
		UPDATE Mail_Mails SET ConversationNo = ConversationNo
		WHERE MailNo = MailNo
	
	END IF;
	
	IF ReplyType = 3 THEN
	
		UPDATE Mail_Mails SET ForwardDate = NOW()
		WHERE MailNo = mail_insertsentmail.originalmailno
		
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
