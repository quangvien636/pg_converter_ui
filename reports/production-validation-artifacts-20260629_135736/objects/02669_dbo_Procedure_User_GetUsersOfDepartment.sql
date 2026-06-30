-- ─── PROCEDURE→FUNCTION: user_getusersofdepartment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.user_getusersofdepartment(integer, boolean);
CREATE OR REPLACE FUNCTION public.user_getusersofdepartment(
    IN departno integer,
    IN isalluser boolean DEFAULT FALSE
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	
	IF IsAllUser = FALSE THEN
		RETURN QUERY
		SELECT B.UserNo, U.UserID, U.Name,
			P.PositionNo, P.Name AS PositionName, P.SortNo AS PositionSortNo,
			D.DepartNo, D.Name AS DepartName,
			U.Enabled
		FROM BelongToDepartment B
		INNER JOIN Users U ON U.UserNo = B.UserNo AND U.Enabled = TRUE
		INNER JOIN Positions P ON P.PositionNo = B.PositionNo
		INNER JOIN Departments D ON D.DepartNo = B.DepartNo
		WHERE B.DepartNo = user_getusersofdepartment.departno
		ORDER BY P.SortNo ASC
	END IF;
	ELSE
		RETURN QUERY
		SELECT B.UserNo, U.UserID, U.Name,
			P.PositionNo, P.Name AS PositionName, P.SortNo AS PositionSortNo,
			D.DepartNo, D.Name AS DepartName,
			U.Enabled
		FROM BelongToDepartment B
		INNER JOIN Users U ON U.UserNo = B.UserNo AND U.Enabled = TRUE
		INNER JOIN Positions P ON P.PositionNo = B.PositionNo
		INNER JOIN Departments D ON D.DepartNo = B.DepartNo
		ORDER BY P.SortNo ASC
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
