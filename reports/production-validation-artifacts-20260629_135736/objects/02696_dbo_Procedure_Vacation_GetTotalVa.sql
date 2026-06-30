-- ─── PROCEDURE→FUNCTION: vacation_gettotalva ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_gettotalva(character varying, integer);
CREATE OR REPLACE FUNCTION public.vacation_gettotalva(
    IN p_uid character varying,
    IN p_y integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

			RETURN QUERY
			SELECT 
				 COALESCE(V.Vacations,0) + X2.Addition1 + X2.Addition2 AS Vacations
			FROM (select * from  Organization_Users where UserID = vacation_gettotalva.p_uid) U 
			LEFT JOIN Vacation_Vacations V ON V.UserNo =  U.UserNo AND (V.years = vacation_gettotalva.p_y)
			LEFT JOIN Vacation_Sum X2 ON u.UserNo =  x2.UsernoI AND X2.YEARS =  vacation_gettotalva.p_y
			LEFT JOIN Vacation_SumRequest X3 ON u.UserNo =  X3.UserNo and x3.years = vacation_gettotalva.p_y;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
