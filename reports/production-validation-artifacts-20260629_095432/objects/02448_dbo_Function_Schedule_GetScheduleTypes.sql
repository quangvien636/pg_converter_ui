-- ─── FUNCTION: schedule_getscheduletypes ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getscheduletypes();
CREATE OR REPLACE FUNCTION public.schedule_getscheduletypes(
) RETURNS TABLE(
    typeno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    name text,
    color text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT TypeNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, Color
	FROM ScheduleTypes;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
