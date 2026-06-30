-- ─── PROCEDURE→FUNCTION: mail_insertmailaccount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_insertmailaccount(integer, integer, timestamp without time zone, character varying, integer, character varying, character varying, boolean, boolean, boolean, boolean, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.mail_insertmailaccount(
    IN userno integer,
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
) RETURNS SETOF record
AS $function$
DECLARE
    accountno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Mail_Accounts (UserNo, ModUserNo, ModDate, Server, Port, PopUser, PopPwd, IsServerAccount, IsSharedAccount, IsDeleteEmlFile, IsWebMail, Name, MailAddress, Enabled)
	VALUES(UserNo, ModUserNo, ModDate, Server, Port, PopUser, PopPwd, IsServerAccount, IsSharedAccount, IsDeleteEmlFile, IsWebMail, Name, MailAddress, Enabled)
	

	AccountNo := lastval();
	RETURN QUERY
	SELECT AccountNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
