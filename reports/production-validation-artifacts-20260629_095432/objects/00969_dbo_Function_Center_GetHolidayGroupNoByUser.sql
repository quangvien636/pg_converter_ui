-- ─── FUNCTION: center_getholidaygroupnobyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getholidaygroupnobyuser(integer);
CREATE OR REPLACE FUNCTION public.center_getholidaygroupnobyuser(
    userno integer
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SET GroupNo = (SELECT /* TOP 1 */ GroupNo FROM Center_HolidayGroups)

	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
