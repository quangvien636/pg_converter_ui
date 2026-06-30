-- ─── FUNCTION: work_getregularworkgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getregularworkgroup(integer);
CREATE OR REPLACE FUNCTION public.work_getregularworkgroup(
    groupno integer
) RETURNS TABLE(
    groupno text,
    historyno text,
    enabled text,
    regdate text,
    moddate text,
    groupname text,
    divisionno text,
    divisionname text,
    userno text,
    username text,
    positionname text,
    iseveryperson text,
    content text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT W.GroupNo, W.HistoryNo, W.Enabled, 
		W.RegDate, H.RegDate AS ModDate, H.Name AS GroupName,
		H.DivisionNo, D.Name AS DivisionName,
		H.UserNo, U.Name AS UserName, P.Name AS PositionName,
		H.IsEveryPerson, H.Content
	FROM RegularWorkGroups W
	INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
	INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
	INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	INNER JOIN RegularWorkGroupDivisions D ON D.DivisionNo = H.DivisionNo
	WHERE W.GroupNo = work_getregularworkgroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
