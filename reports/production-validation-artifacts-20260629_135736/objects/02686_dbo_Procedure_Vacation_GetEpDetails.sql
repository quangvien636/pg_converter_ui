-- ─── PROCEDURE→FUNCTION: vacation_getepdetails ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_getepdetails(integer, integer);
CREATE OR REPLACE FUNCTION public.vacation_getepdetails(
    IN p_y integer,
    IN p_uno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


		RETURN QUERY
		SELECT 
				R.RequestId
			, T.Name as TypeName
			, T.Typei
			, T.TypeId
			, U.UserNo
			, U.UserId as UserID
			, R.Fromd
			, R.Tod
			, R.Note
			, R.DateCreate
			, COALESCE(R.StatusUser,0) StatusUser
			, COALESCE(R.StatusAdmin,0) StatusAdmin
			, R.TypeForAll
			, R.TimeDis
			, COALESCE(R.UserNo,CAST(U.UserNo as varchar) + ',') as UserNos
			, COALESCE(R.departno,'') as Departnos
		FROM  Vacation_RequestEps R
		LEFT JOIN Vacation_Types T on R.TypeId = T.TypeId
		LEFT JOIN Organization_Users u on r.UsernoI = u.UserNo
		where  YEAR(R.Tod) = vacation_getepdetails.p_y  
		AND r.UsernoI = vacation_getepdetails.p_uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
