-- ─── PROCEDURE→FUNCTION: notice_enddateforuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.notice_enddateforuser(integer);
CREATE OR REPLACE FUNCTION public.notice_enddateforuser(
    IN p_uno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT COALESCE((SELECT /* TOP 1 */ ViewEndDate FROM Notice_UserPermission WHERE UserNo = notice_enddateforuser.p_uno),1) AS ViewEndDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
