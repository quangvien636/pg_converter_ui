-- ─── PROCEDURE→FUNCTION: vacation_getrequestepbyuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_getrequestepbyuser(integer, integer);
CREATE OR REPLACE FUNCTION public.vacation_getrequestepbyuser(
    IN p_uno integer,
    IN p_year integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



					 R.RequestId
				FROM  Vacation_RequestEps  R
				where R.UsernoI = vacation_getrequestepbyuser.p_uno and YEAR(r.Tod) = vacation_getrequestepbyuser.p_year);;
DELETE FROM Vacation_RequestEps where UsernoI = vacation_getrequestepbyuser.p_uno and YEAR(Tod) = vacation_getrequestepbyuser.p_year and RequestId != p_type;

				RETURN QUERY
				SELECT 
					 R.RequestId
					 , R.UsernoI as UserNo
					, T.Name as TypeName
					, T.Typei
					, T.TypeId
					, R.UserNo as UserNos
					, R.Fromd
					, R.Tod
					, R.VacationsCount
					, R.Note
					, R.DateCreate
					, R.TypeForAll
				FROM  Vacation_RequestEps  R
				LEFT JOIN Vacation_Types T on R.TypeId = T.TypeId
				where R.UsernoI = vacation_getrequestepbyuser.p_uno and YEAR(r.Tod) = vacation_getrequestepbyuser.p_year;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
