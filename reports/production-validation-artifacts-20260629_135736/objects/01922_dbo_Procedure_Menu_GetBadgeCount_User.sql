-- ─── PROCEDURE→FUNCTION: menu_getbadgecount_user ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.menu_getbadgecount_user(integer);
CREATE OR REPLACE FUNCTION public.menu_getbadgecount_user(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT BadgeNo, UserNo, ModuleNo, BadgeCount FROM Badge 
	WHERE UserNo=menu_getbadgecount_user.userno 
	ORDER BY ModuleNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
