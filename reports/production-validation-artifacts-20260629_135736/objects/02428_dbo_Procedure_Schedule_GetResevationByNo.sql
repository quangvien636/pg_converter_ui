-- ─── PROCEDURE→FUNCTION: schedule_getresevationbyno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresevationbyno(integer);
CREATE OR REPLACE FUNCTION public.schedule_getresevationbyno(
    IN p_rno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	select *  FROM ScheduleResourceReservations 
	WHERE ResourceNo = schedule_getresevationbyno.p_rno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
