-- ─── FUNCTION: permission_getusermenulist ───────────────────────────────
DROP FUNCTION IF EXISTS public.permission_getusermenulist();
CREATE OR REPLACE FUNCTION public.permission_getusermenulist(
) RETURNS TABLE(
    menuno text,
    menuname text,
    menuengname text,
    menujpnname text,
    menuchaname text,
    serviceno text,
    servicetag text,
    serviceurl text,
    level text,
    permissionlevel text
)
AS $function$
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
