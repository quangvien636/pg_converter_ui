-- ─── PROCEDURE→FUNCTION: workingtime_times_v2_update ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_times_v2_update(integer, integer, character varying, double precision);
CREATE OR REPLACE FUNCTION public.workingtime_times_v2_update(
    IN p_wkno integer,
    IN p_wkday integer,
    IN p_time character varying,
    IN p_offset double precision
) RETURNS SETOF record
AS $function$
DECLARE
    p_offsetofcompany character varying;
    checkdatetimeoffset timestamp with time zone;
    p_wkdayofcompany integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN






	SELECT SettingValue INTO p_offsetofcompany FROM WorkingTime_Settings WHERE SettingNo = 7

	CheckDateTimeOffset := switchoffset(CONVERT(datetimeoffset, CheckDateTimeUTC), public."ChangeTimeOffset"(p_Offset));
	p_WKDayOfCompany := CONVERT(INT, CONVERT(VARCHAR(10),switchoffset(CONVERT(datetimeoffset, CheckDateTimeOffset), p_OffsetOfCompany), 112));;
	update WorkingTime_Times_v2 
	WorkingDayOfCompany := p_WKDayOfCompany, CheckDateTimeOffset = CheckDateTimeOffset;
	where WorkingNo = workingtime_times_v2_update.p_wkno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
