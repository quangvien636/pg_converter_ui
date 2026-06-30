-- ─── FUNCTION: work_getregularworkgrouppersons ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getregularworkgrouppersons(integer);
CREATE OR REPLACE FUNCTION public.work_getregularworkgrouppersons(
    historyno integer
) RETURNS TABLE(
    historyno text,
    userno text,
    userid text,
    username text,
    positionname text,
    departname text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT HistoryNo, W.UserNo, U.UserID, U.Name AS UserName,
		P.Name AS PositionName, COALESCE(D.Name,'') as DepartName
	FROM RegularWorkGroupPersons W
	LEFT JOIN Organization_Users U ON U.UserNo = W.UserNo
	LEFT JOIN Organization_BelongToDepartment B ON B.UserNo = W.UserNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	WHERE W.HistoryNo = work_getregularworkgrouppersons.historyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
