-- ─── FUNCTION: schedule_getresourcesenabled ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcesenabled(boolean);
CREATE OR REPLACE FUNCTION public.schedule_getresourcesenabled(
    enabled boolean DEFAULT TRUE
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
	FROM ScheduleResources
	WHERE Enabled = schedule_getresourcesenabled.enabled
	AND IsRepair = FALSE
	AND IsDisposed = FALSE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
