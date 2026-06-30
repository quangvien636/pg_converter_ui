-- ─── FUNCTION: mail_insertmailupload ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertmailupload(integer, integer, bigint, character varying, character varying, character varying, character varying, character varying, bigint, character varying, character varying, character varying, integer, integer, boolean, boolean, integer, boolean, integer, character varying, character varying, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.mail_insertmailupload(
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
    emlfilename character varying,
    todomain character varying,
    regdate timestamp without time zone
) RETURNS TABLE(
    col1 text,
    col2 text
)
AS $function$
DECLARE
    mailno bigint;
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
	

	SET MailNo = lastval()
	
	RETURN QUERY
	SELECT MailNo



	/*
	 * 메일함 메일 개수
	 */
	
	UPDATE Mail_MailBoxs
	SET TotalCount = TotalCount + 1, UnReadCount = UnReadCount + 1
	WHERE BoxNo = mail_insertmailupload.boxno

	UPDATE Mail_UserSettings
	SET CurrentMailBoxSize = CurrentMailBoxSize + Size
	WHERE UserNo = mail_insertmailupload.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
