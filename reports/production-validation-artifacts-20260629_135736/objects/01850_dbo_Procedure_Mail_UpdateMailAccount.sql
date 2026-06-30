-- ─── PROCEDURE→FUNCTION: mail_updatemailaccount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updatemailaccount(bigint, integer, timestamp without time zone, character varying, integer, character varying, character varying, boolean, boolean, boolean, boolean, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatemailaccount(
    IN accountno bigint,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN server character varying,
    IN port integer,
    IN popuser character varying,
    IN poppwd character varying,
    IN isserveraccount boolean,
    IN issharedaccount boolean,
    IN isdeleteemlfile boolean,
    IN iswebmail boolean,
    IN name character varying,
    IN mailaddress character varying,
    IN enabled boolean
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
