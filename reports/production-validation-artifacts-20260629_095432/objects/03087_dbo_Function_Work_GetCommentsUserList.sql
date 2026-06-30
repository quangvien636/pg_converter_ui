-- ─── FUNCTION: work_getcommentsuserlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getcommentsuserlist(integer, integer);
CREATE OR REPLACE FUNCTION public.work_getcommentsuserlist(
    groupno integer,
    commentno integer
) RETURNS TABLE(
    userno text,
    userid text,
    username text,
    positionname text,
    readdate text
)
AS $function$
DECLARE
    tbuserno table
	(
		userno	int
	);
BEGIN



	INSERT INTO tbUserNo
		RETURN QUERY
		select UserNo from WorkGroupAssistants where HistoryNo in(select HistoryNo from WorkGroups where GroupNo = work_getcommentsuserlist.groupno)
		UNION 
		RETURN QUERY
		select UserNo from WorkGroupHistorys where HistoryNo in(select HistoryNo from WorkGroups where GroupNo = work_getcommentsuserlist.groupno)
		UNION 
		RETURN QUERY
		select UserNo from WorkHistorys where HistoryNo in (select HistoryNo from Works where GroupNo = work_getcommentsuserlist.groupno)
		UNION 
		RETURN QUERY
		select UserNo from WorkAssistants where HistoryNo in (select HistoryNo from Works where GroupNo = work_getcommentsuserlist.groupno)		
		UNION 
		RETURN QUERY
		select UserNo from Work_CooperationCommentReference where CommentNo = work_getcommentsuserlist.commentno	
	
	
	RETURN QUERY
	select A.UserNo,UserID, A.Name AS UserName, D.Name AS PositionName , WC.ReadDate as ReadDate from Organization_Users A
	JOIN tbUserNo B on A.UserNo = B.UserNo
	left JOIN Work_CooperationCommentReference WC on A.Userno = WC.UserNo and WC.CommentNo = work_getcommentsuserlist.commentno	
	INNER JOIN Organization_BelongToDepartment C ON C.UserNo = B.UserNo AND C.IsDefault = TRUE
	INNER JOIN Organization_Positions D ON D.PositionNo = C.PositionNo
	LEFT JOIN Organization_Duties E ON E.DutyNo = C.DutyNo
	where A.Enabled = TRUE
	order by D.SortNo, E.SortNo ,A.Name;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
