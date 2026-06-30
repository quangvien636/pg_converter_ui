-- ─── PROCEDURE→FUNCTION: mail_getmailfilters ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getmailfilters(integer);
CREATE OR REPLACE FUNCTION public.mail_getmailfilters(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT F.FilterNo, F.FieldFg, F.ConditionFg, F.ExecFg, F.ExecValue, F.MailBoxNo,
		COALESCE(M.Name, '') AS MailBoxName, F.SortNo,M.SortNo as MSortNo , M.ParentNo
	FROM Mail_MailFilters F 
	LEFT JOIN Mail_MailBoxs M ON M.BoxNo = F.MailBoxNo
	WHERE F.UserNo = mail_getmailfilters.userno
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
