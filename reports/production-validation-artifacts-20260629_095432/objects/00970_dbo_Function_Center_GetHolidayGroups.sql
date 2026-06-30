-- ─── FUNCTION: center_getholidaygroups ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getholidaygroups();
CREATE OR REPLACE FUNCTION public.center_getholidaygroups(
) RETURNS TABLE(
    groupno text,
    moduserno text,
    moddate text,
    title text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT GroupNo, ModUserNo, ModDate, Title
	FROM Center_HolidayGroups;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
