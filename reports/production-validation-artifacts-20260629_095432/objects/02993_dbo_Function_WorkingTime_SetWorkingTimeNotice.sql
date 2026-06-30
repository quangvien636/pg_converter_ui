-- ─── FUNCTION: workingtime_setworkingtimenotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_setworkingtimenotice(integer, integer, date, date, integer);
CREATE OR REPLACE FUNCTION public.workingtime_setworkingtimenotice(
    reguserno integer,
    timetype integer,
    startdate date,
    enddate date,
    locationno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkingTime_Notices (LocationNo,RegUserNo, RegDate, TimeType, StartDate, EndDate, Content)
	VALUES (LocationNo,RegUserNo, NOW(), TimeType, StartDate, EndDate, Content);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
