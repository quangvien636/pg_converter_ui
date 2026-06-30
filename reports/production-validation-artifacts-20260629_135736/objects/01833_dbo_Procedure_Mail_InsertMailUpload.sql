-- ─── PROCEDURE→FUNCTION: mail_insertmailupload ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_insertmailupload(integer, integer, bigint, character varying, character varying, character varying, character varying, character varying, bigint, character varying, character varying, character varying, integer, integer, boolean, boolean, integer, boolean, integer, character varying, character varying, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.mail_insertmailupload(
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
    IN emlfilename character varying,
    IN todomain character varying,
    IN regdate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    mailno bigint;
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
		ToDomain, AccNo,
		Title, Content, 0, 0, Priority, RecipientsCount, ReadCount, IsOneByOne, NULL, NULL, 0, IsImportant, 0, 0,
		2, Size, IsFile, FileCount, RegDate ,null, null, EmlFileName
	)
	

	MailNo := lastval();
	RETURN QUERY
	SELECT MailNo



	/*
	 * 메일함 메일 개수
	 */
	
	UPDATE Mail_MailBoxs
	TotalCount := TotalCount + 1, UnReadCount = UnReadCount + 1;
	WHERE BoxNo = mail_insertmailupload.boxno

	UPDATE Mail_UserSettings
	CurrentMailBoxSize := CurrentMailBoxSize + Size;
	WHERE UserNo = mail_insertmailupload.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
