-- ─── PROCEDURE→FUNCTION: schedule_updatetodogroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updatetodogroup(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_updatetodogroup(
    IN groupno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone
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
