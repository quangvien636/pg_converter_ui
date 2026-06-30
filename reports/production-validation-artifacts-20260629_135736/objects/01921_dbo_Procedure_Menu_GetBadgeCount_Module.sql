-- ─── PROCEDURE→FUNCTION: menu_getbadgecount_module ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.menu_getbadgecount_module(integer, integer);
CREATE OR REPLACE FUNCTION public.menu_getbadgecount_module(
    IN userno integer,
    IN moduleno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT BadgeCount FROM Badge
	WHERE UserNo=menu_getbadgecount_module.userno AND ModuleNo=menu_getbadgecount_module.moduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
