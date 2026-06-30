-- ─── FUNCTION: workingtime_locationlistupdate ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_locationlistupdate(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_locationlistupdate(
    userno integer,
    id integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_LocationList
	SET name=name
	WHERE id=workingtime_locationlistupdate.id AND userno=workingtime_locationlistupdate.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
