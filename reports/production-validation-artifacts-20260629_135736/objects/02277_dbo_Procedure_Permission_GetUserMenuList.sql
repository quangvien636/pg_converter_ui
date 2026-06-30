-- ─── PROCEDURE→FUNCTION: permission_getusermenulist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.permission_getusermenulist();
CREATE OR REPLACE FUNCTION public.permission_getusermenulist(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT 
		UM.MenuNo, 
		MM.MenuName, 
		MM.MenuEngName,
		MM.MenuJpnName,
		MM.MenuChaName,
		MM.ServiceNo, 
		MM.ServiceTag, 
		MM.ServiceUrl, 
		UM.Level, 
		MM.PermissionLevel
	FROM PermissionLevelsUserMenu UM
	LEFT JOIN Biz_Center.public."MainMenuList" MM ON UM.MenuNo = MM.MenuNo
	WHERE UM.UserNo = UserNo
	AND UM.Level <= MM.PermissionLevel;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
