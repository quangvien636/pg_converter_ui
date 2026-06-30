-- ─── PROCEDURE→FUNCTION: schedule_movescheduledate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.schedule_movescheduledate(integer, date);
CREATE OR REPLACE FUNCTION public.schedule_movescheduledate(
    IN scheduleno integer,
    IN changedate date
) RETURNS SETOF record
AS $function$
DECLARE
    startdate date;
    enddate date;
    day integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	SELECT StartDate, EndDate INTO startdate, enddate FROM ScheduleContents WHERE ScheduleNo = schedule_movescheduledate.scheduleno
	DAY := (DATEDIFF(dd,StartDate,ChangeDate));;
	UPDATE ScheduleContents
	ModDate := NOW(),;
		ModUserNo = UserNo,
		StartDate = DATEADD(dd, DAY, StartDate),
		EndDate = DATEADD(dd, DAY, EndDate)
	WHERE ScheduleNo = schedule_movescheduledate.scheduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
