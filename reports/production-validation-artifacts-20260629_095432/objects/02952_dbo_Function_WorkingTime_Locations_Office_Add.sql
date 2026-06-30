-- ─── FUNCTION: workingtime_locations_office_add ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_locations_office_add(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_locations_office_add(
    userno integer,
    worktimeno integer
) RETURNS void
AS $function$
BEGIN


IF ((SELECT COUNT(*) FROM WorkingTime_Locations_Office WHERE UserNo= workingtime_locations_office_add.userno AND WorkTimeNo = workingtime_locations_office_add.worktimeno )<=0)
BEGIN;
	INSERT INTO WorkingTime_Locations_Office(UserNo,WorkTimeNo)
	VALUES(UserNo,WorkTimeNo)
END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
