-- ─── FUNCTION: menu_getbadgecount_user ───────────────────────────────
DROP FUNCTION IF EXISTS public.menu_getbadgecount_user(integer);
CREATE OR REPLACE FUNCTION public.menu_getbadgecount_user(
    userno integer
) RETURNS TABLE(
    badgeno text,
    userno text,
    moduleno text,
    badgecount text
)
AS $function$
BEGIN



	RETURN QUERY
	SELECT BadgeNo, UserNo, ModuleNo, BadgeCount FROM Badge 
	WHERE UserNo=menu_getbadgecount_user.userno 
	ORDER BY ModuleNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
