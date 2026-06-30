-- ─── FUNCTION: schedule_getresourceisadmin ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourceisadmin();
CREATE OR REPLACE FUNCTION public.schedule_getresourceisadmin(
) RETURNS TABLE(
    cnt text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT COUNT(*) AS CNT
	FROM ScheduleResourcesBuyGroup
	WHERE (MainManagerNo = UserNo OR SubManagerNo = UserNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
