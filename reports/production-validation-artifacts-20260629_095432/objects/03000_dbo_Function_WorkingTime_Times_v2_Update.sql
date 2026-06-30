-- ─── FUNCTION: workingtime_times_v2_update ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_times_v2_update(integer, integer, character varying, double precision);
CREATE OR REPLACE FUNCTION public.workingtime_times_v2_update(
    p_wkno integer,
    p_wkday integer,
    p_time character varying,
    p_offset double precision
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    p_offsetofcompany character varying;
    checkdatetimeoffset datetimeoffset;
    p_wkdayofcompany integer;
BEGIN






	SELECT p_OffsetOfCompany = SettingValue FROM WorkingTime_Settings WHERE SettingNo = 7

	SET CheckDateTimeOffset = switchoffset(CONVERT(datetimeoffset, CheckDateTimeUTC), public."ChangeTimeOffset"(p_Offset)); 

	SET p_WKDayOfCompany = CONVERT(INT, CONVERT(VARCHAR(10),switchoffset(CONVERT(datetimeoffset, CheckDateTimeOffset), p_OffsetOfCompany), 112))


	update WorkingTime_Times_v2 
	set WorkingDayOfCompany = p_WKDayOfCompany, CheckDateTimeOffset = CheckDateTimeOffset
	where WorkingNo = workingtime_times_v2_update.p_wkno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
