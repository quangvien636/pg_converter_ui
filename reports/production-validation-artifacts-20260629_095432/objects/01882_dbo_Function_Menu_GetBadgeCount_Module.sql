-- ─── FUNCTION: menu_getbadgecount_module ───────────────────────────────
DROP FUNCTION IF EXISTS public.menu_getbadgecount_module(integer, integer);
CREATE OR REPLACE FUNCTION public.menu_getbadgecount_module(
    userno integer,
    moduleno integer
) RETURNS TABLE(
    badgecount text
)
AS $function$
BEGIN



	RETURN QUERY
	SELECT BadgeCount FROM Badge
	WHERE UserNo=menu_getbadgecount_module.userno AND ModuleNo=menu_getbadgecount_module.moduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
