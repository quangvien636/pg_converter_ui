-- ─── FUNCTION: schedule_getresources ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresources();
CREATE OR REPLACE FUNCTION public.schedule_getresources(
) RETURNS TABLE(
    resourceno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    categoryno text,
    name text,
    enabled text,
    isrepair text,
    isdisposed text,
    isreservation text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ResourceNo, RegUserNo, RegDate, ModUserNo, ModDate, CategoryNo, Name, Enabled, IsRepair, IsDisposed, IsReservation
	FROM ScheduleResources;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
