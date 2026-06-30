-- ─── PROCEDURE→FUNCTION: mail_deletemailfilter ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_deletemailfilter(bigint);
CREATE OR REPLACE FUNCTION public.mail_deletemailfilter(
    IN filterno bigint
) RETURNS void
AS $function$
BEGIN



	SELECT UserNo INTO userno FROM Mail_MailFilters WHERE FilterNo = mail_deletemailfilter.filterno
	
	UPDATE Mail_MailFilters SET SortNo = SortNo - 1 WHERE UserNo = UserNo AND SortNo > SortOrd

    DELETE FROM Mail_MailFilters WHERE FilterNo = mail_deletemailfilter.filterno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
