-- ─── PROCEDURE→FUNCTION: schedule_deleteresourcedispose ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_deleteresourcedispose(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteresourcedispose(
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    resourceno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT  INTO  FROM ScheduleResourcesDispose
	WHERE DisposeNo = DisposeNo;
	
	DELETE FROM ScheduleResourcesDispose
	WHERE DisposeNo = DisposeNo
	
	UPDATE ScheduleResources
	IsDisposed := 0,;
		ModUserNo = schedule_deleteresourcedispose.userno,
		ModDate = NOW()
	WHERE ResourceNo = ResourceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
