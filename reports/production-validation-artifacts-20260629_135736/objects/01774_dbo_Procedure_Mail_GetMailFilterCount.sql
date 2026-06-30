-- ─── PROCEDURE→FUNCTION: mail_getmailfiltercount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getmailfiltercount(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.mail_getmailfiltercount(
    IN userno integer,
    IN fieldfg character varying,
    IN conditionfg character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT COUNT(*)
	FROM Mail_MailFilters
	WHERE UserNo = mail_getmailfiltercount.userno AND FieldFg = mail_getmailfiltercount.fieldfg AND ConditionFg = mail_getmailfiltercount.conditionfg AND ExecValue = ExecValue;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
