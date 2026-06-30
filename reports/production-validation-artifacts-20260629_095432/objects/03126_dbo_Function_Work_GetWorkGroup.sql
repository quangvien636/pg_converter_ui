-- ─── FUNCTION: work_getworkgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getworkgroup(integer);
CREATE OR REPLACE FUNCTION public.work_getworkgroup(
    groupno integer
) RETURNS TABLE(
    groupno text,
    groupname text,
    content text,
    userno text,
    userid text,
    username text,
    positionname text,
    historyno text,
    regdate text,
    moddate text,
    completedate text,
    startdate text,
    islock text,
    state text,
    enabled text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT W.GroupNo, H.Name AS GroupName, H.Content,
		H.UserNo, U.UserID, U.Name AS UserName, P.Name AS PositionName, W.HistoryNo,
		W.RegDate, H.RegDate AS ModDate, H.CompleteDate, H.StartDate ,W.IsLock, W.State, W.Enabled
	FROM WorkGroups W
	INNER JOIN WorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
	INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
	INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	WHERE W.GroupNo = work_getworkgroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
