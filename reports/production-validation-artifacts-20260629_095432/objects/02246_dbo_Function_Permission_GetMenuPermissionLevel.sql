-- ─── FUNCTION: permission_getmenupermissionlevel ───────────────────────────────
DROP FUNCTION IF EXISTS public.permission_getmenupermissionlevel();
CREATE OR REPLACE FUNCTION public.permission_getmenupermissionlevel(
) RETURNS TABLE(
    userno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    level text
)
AS $function$
DECLARE
    menuno integer;
BEGIN


	SELECT MenuNo = MenuNo FROM Biz_Center.public."MainMenuList"
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
