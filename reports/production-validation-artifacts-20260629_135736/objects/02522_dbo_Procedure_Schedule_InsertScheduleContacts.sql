-- ─── PROCEDURE→FUNCTION: schedule_insertschedulecontacts ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertschedulecontacts(integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertschedulecontacts(
    IN userseq integer DEFAULT 0,
    IN groupno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	IF GroupNo = 0 THEN;
		INSERT INTO ScheduleContentsContacts 
		(ScheduleNo, UserSeq, GroupNo)
		VALUES
		(ScheduleNo, UserSeq, 0)
	END IF;
	ELSE;
		INSERT INTO ScheduleContentsContacts 
		(ScheduleNo, UserSeq, GroupNo)
		VALUES
		(ScheduleNo, 0, GroupNo)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
