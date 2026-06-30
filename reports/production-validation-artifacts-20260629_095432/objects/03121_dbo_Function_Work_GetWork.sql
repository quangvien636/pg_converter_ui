-- ─── FUNCTION: work_getwork ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getwork(integer);
CREATE OR REPLACE FUNCTION public.work_getwork(
    workno integer
) RETURNS TABLE(
    workno text,
    title text,
    content text,
    userno text,
    username text,
    positionname text,
    groupno text,
    historyno text,
    divisionno text,
    divisionname text,
    worktime text,
    completionrate text,
    reguserno text,
    regdate text,
    moddate text,
    completedate text,
    iseveryperson text,
    enabled text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT W.WorkNo, H.Title, H.Content,
		H.UserNo, U.Name AS UserName, P.Name AS PositionName, W.GroupNo, W.HistoryNo,
		H.DivisionNo, WD.Name AS DivisionName, H.WorkTime, W.CompletionRate,
		W.RegUserNo, W.RegDate, H.RegDate AS ModDate, H.CompleteDate,
		H.IsEveryPerson, W.Enabled
	FROM Works W
	INNER JOIN WorkHistorys H ON H.HistoryNo = W.HistoryNo
	INNER JOIN WorkDivisions WD ON WD.DivisionNo = H.DivisionNo
	INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
	INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	WHERE W.WorkNo = work_getwork.workno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
