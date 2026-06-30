-- ─── FUNCTION: dday_getcountofappbadge ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_getcountofappbadge(integer);
CREATE OR REPLACE FUNCTION public.dday_getcountofappbadge(
    userno integer DEFAULT 70
) RETURNS TABLE(
    badgecount text,
    listofdays text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT BadgeCount, ListOfDays FROM DDay_CountOfAppBadge WHERE UserNo = dday_getcountofappbadge.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
