-- ─── FUNCTION: workingtimeworks_checkin_lunch ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtimeworks_checkin_lunch(timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.workingtimeworks_checkin_lunch(
    checkintime timestamp without time zone,
    timetype integer
) RETURNS timestamp without time zone
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
DECLARE
    result timestamp without time zone;
    mytime timestamp without time zone;
    startlunch character varying;
    endlunch character varying;
    dstartlunch timestamp without time zone;
    dendlunch timestamp without time zone;
    dcheckintime timestamp without time zone;
    dstartlunchfloat double precision;
    dendlunchfloat double precision;
    dcheckintimefloat double precision;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	










	SET StartLunch = (SELECT SettingValue FROM public."WorkingTime_Settings" where SettingNo = 4)
	SET EndLunch = (SELECT SettingValue FROM public."WorkingTime_Settings" where SettingNo = 5)

	SET DStartLunch = LEFT(StartLunch,2)+':' || SUBSTRING(StartLunch,3,2)+':00'
	SET DEndLunch = LEFT(EndLunch,2)+':' || SUBSTRING(EndLunch,3,2)+':00'

	--SET DCheckInTime = LEFT(CheckInTime,2)+':' || SUBSTRING(CheckInTime,3,2)+':' || RIGHT(CheckInTime,2)
	SET DCheckInTime = workingtimeworks_checkin_lunch.checkintime
	--SET DCheckInTime = DATEADD(hour, TimeOffset, DCheckInTime)

	SET DStartLunchFloat = cast(DStartLunch AS FLOAT)
	SET DEndLunchFloat = cast(DEndLunch AS FLOAT)

	SET DCheckInTimeFloat = cast(DCheckInTime AS FLOAT)
	SET DCheckInTimeFloat = DCheckInTimeFloat - floor(DCheckInTimeFloat) 

	IF TimeType = 1
		BEGIN
			IF DCheckInTimeFloat < DStartLunchFloat OR DCheckInTimeFloat >= DEndLunchFloat
				BEGIN
					SET myTime = DCheckInTimeFloat
				END
			ELSE IF DCheckInTimeFloat >= DStartLunchFloat AND DCheckInTimeFloat < DEndLunchFloat
				BEGIN
					SET myTime = DEndLunchFloat
				END
		END
	ELSE IF TimeType = 3
		BEGIN
			IF DCheckInTimeFloat <= DStartLunchFloat OR DCheckInTimeFloat > DEndLunchFloat
				BEGIN
					SET myTime = DCheckInTimeFloat
				END
			ELSE IF DCheckInTimeFloat > DStartLunchFloat AND DCheckInTimeFloat <= DEndLunchFloat
				BEGIN
					SET myTime = DStartLunchFloat
				END
		END

	
	set myTime = convert(DATETIME, myTime)

	-- Shows 1900-01-01 19:47:16.123
	SET RESULT =  DATEADD(day, (CONVERT(date, DCheckInTime::date - 0::date)), myTime)

	RETURN RESULT;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
