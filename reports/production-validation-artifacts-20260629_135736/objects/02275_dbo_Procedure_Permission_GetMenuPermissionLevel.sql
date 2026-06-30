-- ─── PROCEDURE→FUNCTION: permission_getmenupermissionlevel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.permission_getmenupermissionlevel();
CREATE OR REPLACE FUNCTION public.permission_getmenupermissionlevel(
) RETURNS SETOF record
AS $function$
DECLARE
    menuno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT MenuNo INTO menuno FROM Biz_Center.public."MainMenuList"
	WHERE PATINDEX(ServiceUrl || '%',Path) > 0
	
	RETURN QUERY
	SELECT UserNo, RegUserNo, RegDate, ModUserNo, ModDate, Level
	FROM PermissionLevelsUserMenu
	WHERE UserNo = UserNo
	AND MenuNo = MenuNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
