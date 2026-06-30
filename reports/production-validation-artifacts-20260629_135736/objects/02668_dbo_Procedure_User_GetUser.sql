-- ─── PROCEDURE→FUNCTION: user_getuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.user_getuser(integer);
CREATE OR REPLACE FUNCTION public.user_getuser(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT B.UserNo, U.UserID, U.Name,
		P.PositionNo, P.Name AS PositionName, P.SortNo AS PositionSortNo,
		D.DepartNo, D.Name AS DepartName,
		U.Enabled
	FROM BelongToDepartment B
	INNER JOIN Users U ON U.UserNo = B.UserNo
	INNER JOIN Positions P ON P.PositionNo = B.PositionNo
	INNER JOIN Departments D ON D.DepartNo = B.DepartNo
	WHERE U.UserNo = user_getuser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
