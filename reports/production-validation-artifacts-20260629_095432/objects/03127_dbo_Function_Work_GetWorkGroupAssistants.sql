-- ─── FUNCTION: work_getworkgroupassistants ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getworkgroupassistants(integer);
CREATE OR REPLACE FUNCTION public.work_getworkgroupassistants(
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
		P.Name AS PositionName, D.Name AS DepartName
	FROM WorkGroupAssistants W
	LEFT JOIN Organization_Users U ON U.UserNo = W.UserNo
	LEFT JOIN Organization_BelongToDepartment B ON B.UserNo = W.UserNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	WHERE W.HistoryNo = work_getworkgroupassistants.historyno
	ORDER BY P.SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
