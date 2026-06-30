-- ─── FUNCTION: user_getallusers ───────────────────────────────
DROP FUNCTION IF EXISTS public.user_getallusers(boolean);
CREATE OR REPLACE FUNCTION public.user_getallusers(
    issimple boolean
) RETURNS TABLE(
    userno text,
    userid text,
    name text,
    positionname text,
    departname text
)
AS $function$
BEGIN


	IF (IsSimple = FALSE) BEGIN

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
	
	END
	
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
