-- ─── FUNCTION: schedule_insertschedulecontacts ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertschedulecontacts(integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertschedulecontacts(
    userseq integer DEFAULT 0,
    groupno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	IF GroupNo = 0 
	BEGIN;
		INSERT INTO ScheduleContentsContacts 
		(ScheduleNo, UserSeq, GroupNo)
		VALUES
		(ScheduleNo, UserSeq, 0)
	END	
	ELSE
	BEGIN;
		INSERT INTO ScheduleContentsContacts 
		(ScheduleNo, UserSeq, GroupNo)
		VALUES
		(ScheduleNo, 0, GroupNo)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
