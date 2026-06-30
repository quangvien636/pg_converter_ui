-- ─── PROCEDURE→FUNCTION: user_getallusers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.user_getallusers(boolean);
CREATE OR REPLACE FUNCTION public.user_getallusers(
    IN issimple boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF IsSimple = FALSE THEN

		RETURN QUERY
		SELECT B.UserNo, U.UserID, U.Name,
			P.PositionNo, P.Name AS PositionName, P.SortNo AS PositionSortNo,
			D.DepartNo, D.Name AS DepartName
		FROM BelongToDepartment B
		INNER JOIN Users U ON U.UserNo = B.UserNo
		INNER JOIN Positions P ON P.PositionNo = B.PositionNo
		INNER JOIN Departments D ON D.DepartNo = B.DepartNo
		WHERE U.Enabled = TRUE
		ORDER BY U.Name ASC
	
	END IF;
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT B.UserNo, U.UserID, U.Name, P.Name AS PositionName, D.Name AS DepartName
		FROM BelongToDepartment B
		INNER JOIN Users U ON U.UserNo = B.UserNo
		INNER JOIN Positions P ON P.PositionNo = B.PositionNo
		INNER JOIN Departments D ON D.DepartNo = B.DepartNo
		WHERE U.Enabled = TRUE
		ORDER BY U.Name ASC
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
