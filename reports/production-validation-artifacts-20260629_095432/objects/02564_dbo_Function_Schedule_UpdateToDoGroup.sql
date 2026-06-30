-- ─── FUNCTION: schedule_updatetodogroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updatetodogroup(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_updatetodogroup(
    groupno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE ScheduleToDoGroups SET
		ModUserNo = schedule_updatetodogroup.moduserno,
		ModDate = schedule_updatetodogroup.moddate,
		Name = Name
	WHERE GroupNo = schedule_updatetodogroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
