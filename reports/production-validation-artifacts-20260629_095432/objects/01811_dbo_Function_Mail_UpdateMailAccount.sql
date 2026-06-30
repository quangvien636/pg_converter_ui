-- ─── FUNCTION: mail_updatemailaccount ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemailaccount(bigint, integer, timestamp without time zone, character varying, integer, character varying, character varying, boolean, boolean, boolean, boolean, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatemailaccount(
    accountno bigint,
    moduserno integer,
    moddate timestamp without time zone,
    server character varying,
    port integer,
    popuser character varying,
    poppwd character varying,
    isserveraccount boolean,
    issharedaccount boolean,
    isdeleteemlfile boolean,
    iswebmail boolean,
    name character varying,
    mailaddress character varying,
    enabled boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_Accounts SET
		ModUserNo = mail_updatemailaccount.moduserno,
		ModDate = mail_updatemailaccount.moddate,
		Server = mail_updatemailaccount.server,
		Port = mail_updatemailaccount.port,
		PopUser = mail_updatemailaccount.popuser,
		PopPwd = mail_updatemailaccount.poppwd,
		IsServerAccount = mail_updatemailaccount.isserveraccount,
		IsSharedAccount = mail_updatemailaccount.issharedaccount,
		IsDeleteEmlFile = mail_updatemailaccount.isdeleteemlfile,
		IsWebMail = mail_updatemailaccount.iswebmail,
		Name = mail_updatemailaccount.name,
		MailAddress = mail_updatemailaccount.mailaddress,
		Enabled = mail_updatemailaccount.enabled
	WHERE AccountNo = mail_updatemailaccount.accountno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
