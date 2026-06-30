-- ─── FUNCTION: uf_caltimelateignoretimezone ───────────────────────────────
DROP FUNCTION IF EXISTS public.uf_caltimelateignoretimezone();
CREATE OR REPLACE FUNCTION public.uf_caltimelateignoretimezone(
) RETURNS character varying
AS $function$
DECLARE
    currentoffset character varying;
BEGIN

	
	IF (timecheckin IS NULL)
		RETURN 0;

	-- Declare the return variable here


	SET TotalMinuteLate = 0
	SELECT CurrentOffset = SettingValue from public."WorkingTime_Settings" where SettingNo=7

		--DECLARE timecheckin datetimeoffset
		--SET timecheckin = '2016-06-19 16:22:41 -12:00'
	--SELECT timecheckin = SWITCHOFFSET ( timecheckin, CurrentOffset )
	SELECT MinuteStart = convert(int,left(SettingValue,2),0)*60 || convert(int,right(SettingValue,2),0) from public."WorkingTime_Settings" where SettingNo=1
	SELECT TotalMinuteLate = DATEPART(HOUR, timecheckin)*60 || DATEPART(MINUTE, timecheckin) - MinuteStart
	

	-- Return the result of the function
	RETURN CASE 
					WHEN TotalMinuteLate<0
						THEN 0
					ELSE TotalMinuteLate
				END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
