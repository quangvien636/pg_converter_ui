-- ─── FUNCTION: user_getuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.user_getuser(integer);
CREATE OR REPLACE FUNCTION public.user_getuser(
    userno integer
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
