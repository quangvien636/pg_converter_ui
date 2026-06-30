-- ─── PROCEDURE→FUNCTION: schedule_getgooglecontents ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getgooglecontents(integer, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_getgooglecontents(
    IN p_uno integer,
    IN p_sd timestamp without time zone,
    IN p_ed timestamp without time zone
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


		RETURN QUERY
		select * from ScheduleGoogleContents s where RegUserNo = schedule_getgooglecontents.p_uno and s.StartDate <= schedule_getgooglecontents.p_ed AND S.EndDate >= schedule_getgooglecontents.p_sd;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
