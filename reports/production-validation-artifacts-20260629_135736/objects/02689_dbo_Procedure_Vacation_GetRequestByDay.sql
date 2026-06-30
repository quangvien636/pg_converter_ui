-- ─── PROCEDURE→FUNCTION: vacation_getrequestbyday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_getrequestbyday(character varying, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.vacation_getrequestbyday(
    IN p_uid character varying,
    IN p_from timestamp without time zone,
    IN p_to timestamp without time zone
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



				RETURN QUERY
				SELECT 
					 *
				FROM  Vacation_Requests R
				WHERE R.UserNo = p_Uno 
					AND (
					( p_from < R.Fromd and R.Fromd  < vacation_getrequestbyday.p_to)
					or ( p_from < R.Tod and  R.Tod < vacation_getrequestbyday.p_to )
					or (R.Fromd = vacation_getrequestbyday.p_from  and  R.Tod = vacation_getrequestbyday.p_to )
					);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
