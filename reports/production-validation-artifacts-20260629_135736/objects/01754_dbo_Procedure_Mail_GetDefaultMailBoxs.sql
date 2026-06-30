-- ─── PROCEDURE→FUNCTION: mail_getdefaultmailboxs ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getdefaultmailboxs(integer);
CREATE OR REPLACE FUNCTION public.mail_getdefaultmailboxs(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT BoxNo, UserNo, Name, ParentNo, SortNo, ModDate, TotalCount, UnReadCount, IsShare
	FROM Mail_MailBoxs
	WHERE UserNo = mail_getdefaultmailboxs.userno AND ParentNo = -1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
