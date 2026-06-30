-- ─── PROCEDURE→FUNCTION: schedule_updateddaygroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updateddaygroup(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_updateddaygroup(
    IN groupno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE ScheduleDdayGroups SET
		ModUserNo = schedule_updateddaygroup.moduserno,
		ModDate = schedule_updateddaygroup.moddate,
		Name = Name
	WHERE GroupNo = schedule_updateddaygroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
