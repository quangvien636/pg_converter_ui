-- ─── PROCEDURE→FUNCTION: vacation_requestep ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_requestep(integer);
CREATE OR REPLACE FUNCTION public.vacation_requestep(
    IN p_no integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



				RETURN QUERY
				SELECT 
					 R.RequestId
					, U.UserID
					, U.Name
					, T.Name as TypeName
					, T.Typei
					, T.TypeId
					, R.UserNo
					, R.Fromd
					, R.Tod
					, R.VacationsCount
					, R.Note
					, R.DateCreate
					, COALESCE(R.StatusUser,0) StatusUser
					, COALESCE(R.StatusAdmin,0) StatusAdmin
					, V.Vacations
					, V.Used
					, R.TypeForAll
				FROM  Vacation_RequestEps R
				LEFT JOIN Vacation_Vacations v ON R.UserNo = V.UserNo
				LEFT JOIN Vacation_Types T on R.TypeId = T.TypeId
				LEFT JOIN Organization_Users U ON U.UserNo = R.UserNo
				where R.RequestId = vacation_requestep.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
