-- ─── FUNCTION: workingtimeworks ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtimeworks(character varying);
CREATE OR REPLACE FUNCTION public.workingtimeworks(
    starttimework character varying
) RETURNS double precision
AS $function$
DECLARE
    result double precision;
    starttime timestamp without time zone;
    endtime timestamp without time zone;
    starttimefloat double precision;
    endtimefloat double precision;
BEGIN






	--SET startTime = LEFT(StartTimeWork,2)+':' || SUBSTRING(StartTimeWork,3,2)+':' || RIGHT(StartTimeWork,2)
	--SET endTime =LEFT(EndTimeWork,2)+':' || SUBSTRING(EndTimeWork,3,2)+':' || RIGHT(EndTimeWork,2)
	SET startTime = workingtimeworks.starttimework
	SET endTime = EndTimeWork

	-- chuyen ngay sang float tru di ngay chi lay gio
	

	SET startTimeFloat = cast(startTime AS FLOAT)
	SET endTimeFloat = cast(endTime AS FLOAT)

	---lấy giờ


	SET startTimeFloat = startTimeFloat - checkDateFloat
	SET endTimeFloat = endTimeFloat - checkDateFloat

	IF startTimeFloat < endTimeFloat 
	BEGIN
		SET RESULT =  endTimeFloat - startTimeFloat
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
