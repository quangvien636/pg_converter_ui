-- ─── FUNCTION: organization_getcomposeusers ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getcomposeusers(integer);
CREATE OR REPLACE FUNCTION public.organization_getcomposeusers(
    departno integer
) RETURNS TABLE(
    userno text,
    userid text,
    username text,
    positionno text,
    positionname text,
    positionsortno text,
    departno text,
    departname text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT B.UserNo, U.UserID, U.Name AS UserName,
		P.PositionNo, P.Name AS PositionName, P.SortNo AS PositionSortNo,
		D.DepartNo, D.Name AS DepartName
	FROM Organization_BelongToDepartment B
	INNER JOIN Organization_Users U ON U.UserNo = B.UserNo
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	WHERE B.DepartNo = organization_getcomposeusers.departno AND U.Enabled = TRUE
	ORDER BY P.SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
