-- ─── PROCEDURE→FUNCTION: vacation_updaterequest ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_updaterequest(integer, timestamp without time zone, timestamp without time zone, double precision, integer);
CREATE OR REPLACE FUNCTION public.vacation_updaterequest(
    IN p_id integer,
    IN p_from timestamp without time zone,
    IN p_to timestamp without time zone,
    IN p_vcount double precision,
    IN p_type integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

update  Vacation_Requests set
           Fromd = vacation_updaterequest.p_from
           ,Tod = vacation_updaterequest.p_to
		   ,VacationsCount = vacation_updaterequest.p_vcount
		   ,DateUpdate = NOW()
		   ,TypeId = vacation_updaterequest.p_type
		   where RequestId = vacation_updaterequest.p_id;
			RETURN QUERY
			select p_id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
