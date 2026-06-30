-- ─── FUNCTION: workingtime_times_v2_insert ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_times_v2_insert(integer, integer, character varying, double precision);
CREATE OR REPLACE FUNCTION public.workingtime_times_v2_insert(
    workingno integer,
    workingday integer,
    checktime character varying,
    timeoffset double precision
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    timeoffsetofcompany character varying;
    checkdatetimeoffset datetimeoffset;
    workingdayofcompany integer;
BEGIN






	SELECT TimeOffSetOfCompany = SettingValue FROM WorkingTime_Settings WHERE SettingNo = 7

	SET CheckDateTimeOffset = switchoffset(CONVERT(datetimeoffset, CheckDateTimeUTC), public."ChangeTimeOffset"(TimeOffset)); 

	SET WorkingDayOfCompany = CONVERT(INT, CONVERT(VARCHAR(10),switchoffset(CONVERT(datetimeoffset, CheckDateTimeOffset), TimeOffSetOfCompany), 112))

	INSERT INTO WorkingTime_Times_v2 (WorkingNo, WorkingDayOfCompany, CheckDateTimeOffset) VALUES (WorkingNo,WorkingDayOfCompany,CheckDateTimeOffset);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
