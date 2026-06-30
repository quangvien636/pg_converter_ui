-- ─── FUNCTION: user_getusersofdepartment ───────────────────────────────
DROP FUNCTION IF EXISTS public.user_getusersofdepartment(integer, boolean);
CREATE OR REPLACE FUNCTION public.user_getusersofdepartment(
    departno integer,
    isalluser boolean DEFAULT FALSE
) RETURNS TABLE(
    userno text,
    userid text,
    name text,
    positionno text,
    positionname text,
    positionsortno text,
    departno text,
    departname text,
    enabled text
)
AS $function$
BEGIN


	
	IF IsAllUser = FALSE
	BEGIN
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
	END
	ELSE
	BEGIN
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
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
