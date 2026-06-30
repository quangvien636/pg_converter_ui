-- ─── PROCEDURE→FUNCTION: workingtime_times_v2_insert ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_times_v2_insert(integer, integer, character varying, double precision);
CREATE OR REPLACE FUNCTION public.workingtime_times_v2_insert(
    IN workingno integer,
    IN workingday integer,
    IN checktime character varying,
    IN timeoffset double precision
) RETURNS SETOF record
AS $function$
DECLARE
    timeoffsetofcompany character varying;
    checkdatetimeoffset timestamp with time zone;
    workingdayofcompany integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN






	SELECT SettingValue INTO timeoffsetofcompany FROM WorkingTime_Settings WHERE SettingNo = 7

	CheckDateTimeOffset := switchoffset(CONVERT(datetimeoffset, CheckDateTimeUTC), public."ChangeTimeOffset"(TimeOffset));
	WorkingDayOfCompany := CONVERT(INT, CONVERT(VARCHAR(10),switchoffset(CONVERT(datetimeoffset, CheckDateTimeOffset), TimeOffSetOfCompany), 112));;
	INSERT INTO WorkingTime_Times_v2 (WorkingNo, WorkingDayOfCompany, CheckDateTimeOffset) VALUES (WorkingNo,WorkingDayOfCompany,CheckDateTimeOffset);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
