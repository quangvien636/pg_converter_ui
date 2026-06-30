-- ─── FUNCTION: workingtimeworksaddlunch ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtimeworksaddlunch(timestamp without time zone, timestamp without time zone, double precision);
CREATE OR REPLACE FUNCTION public.workingtimeworksaddlunch(
    starttimework timestamp without time zone,
    endtimework timestamp without time zone,
    timeoffset double precision
) RETURNS double precision
AS $function$
DECLARE
    result double precision;
    timework double precision;
    timelunch double precision;
    startlunchfloat double precision;
    endlunchfloat double precision;
    startlunch character varying;
    endlunch character varying;
    dstartlunch timestamp without time zone;
    dendlunch timestamp without time zone;
    checkinfloat double precision;
    checkoutfloat double precision;
BEGIN










	--DECLARE DStartTimeWork DATETIME
	--DECLARE DEndTimeWork DATETIME



	SET StartLunch = (SELECT SettingValue FROM public."WorkingTime_Settings" where SettingNo = 4)
	SET EndLunch = (SELECT SettingValue FROM public."WorkingTime_Settings" where SettingNo = 5)

	SET DStartLunch = LEFT(StartLunch,2) + ':' || SUBSTRING(StartLunch,3,2) + ':00'
	SET DEndLunch = LEFT(EndLunch,2) + ':' || SUBSTRING(EndLunch,3,2) + ':00'

	SET DStartLunch = public."ConverToUtcTime"(TimeOffset, DStartLunch)
	SET DEndLunch = public."ConverToUtcTime"(TimeOffset, DEndLunch)

	--SET DStartTimeWork = LEFT(StartTimeWork,2)+':' || SUBSTRING(StartTimeWork,3,2)+':' || RIGHT(StartTimeWork,2) 
	--SET DEndTimeWork = LEFT(EndTimeWork,2)+':' || SUBSTRING(EndTimeWork,3,2)+':' || RIGHT(EndTimeWork,2) 
	--SET DStartTimeWork = StartTimeWork
	--SET DEndTimeWork = EndTimeWork

	SET StartLunchFloat = cast(DStartLunch AS FLOAT)
	SET EndLunchFloat = cast(DEndLunch AS FLOAT)

	SET checkInFloat = cast(StartTimeWork AS FLOAT)
	SET checkOutFloat = cast(EndTimeWork AS FLOAT)



	SET checkInFloat = checkInFloat - checkDateFloat 
	SET checkOutFloat = checkOutFloat - checkDateFloat 


IF checkInFloat < checkOutFloat 
BEGIN

	IF checkInFloat < StartLunchFloat AND checkOutFloat > EndLunchFloat
		BEGIN
			SET TimeWork = checkOutFloat - checkInFloat
			SET TimeLunch =  EndLunchFloat - StartLunchFloat
			SET RESULT = TimeWork - TimeLunch
		END
	ELSE IF checkInFloat < StartLunchFloat AND checkOutFloat <= StartLunchFloat
		BEGIN
			SET TimeWork = checkOutFloat - checkInFloat
			SET RESULT = TimeWork
		END
	ELSE IF checkInFloat < StartLunchFloat AND checkOutFloat <= EndLunchFloat
		BEGIN
			SET TimeWork = StartLunchFloat - checkInFloat
			SET RESULT = TimeWork
		END
	ELSE IF checkInFloat >= StartLunchFloat AND checkInFloat <= EndLunchFloat AND checkOutFloat > EndLunchFloat
		BEGIN
			SET TimeWork = checkOutFloat - EndLunchFloat
			SET RESULT = TimeWork
		END
	ELSE IF checkInFloat > EndLunchFloat
		BEGIN
			SET TimeWork = checkOutFloat - checkInFloat
			SET RESULT = TimeWork
		END
	ELSE
		BEGIN
			SET TimeWork = 0
			SET RESULT = TimeWork
		END
END
ELSE
	BEGIN
		SET RESULT = 0
	END

	RETURN RESULT;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
