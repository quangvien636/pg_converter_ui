-- ─── FUNCTION: mail_updatemail ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemail(integer, bigint, character varying, character varying, character varying, character varying, character varying, bigint, character varying, character varying, character varying, integer, integer, boolean, boolean, integer, boolean, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.mail_updatemail(
    userno integer,
    mailno bigint,
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
    reservedate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_Mails SET
		FromName = mail_updatemail.fromname,
		FromAddr = mail_updatemail.fromaddr,
		To = mail_updatemail.to,
		Cc = mail_updatemail.cc,
		Bcc = mail_updatemail.bcc,
		AccNo = mail_updatemail.accno,
		Title = mail_updatemail.title,
		Content = mail_updatemail.content,
		Priority = mail_updatemail.priority,
		RecipientsCount = mail_updatemail.recipientscount,
		ReadCount = mail_updatemail.readcount,
		IsOneByOne = mail_updatemail.isonebyone,
		IsImportant = mail_updatemail.isimportant,
		Size = mail_updatemail.size,
		IsFile = mail_updatemail.isfile,
		FileCount = mail_updatemail.filecount,
		RegDate = NOW(),
		ReserveDate = mail_updatemail.reservedate
	WHERE MailNo = mail_updatemail.mailno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
