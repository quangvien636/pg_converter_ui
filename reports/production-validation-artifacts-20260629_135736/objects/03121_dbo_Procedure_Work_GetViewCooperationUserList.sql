-- ─── PROCEDURE→FUNCTION: work_getviewcooperationuserlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getviewcooperationuserlist(integer, integer);
CREATE OR REPLACE FUNCTION public.work_getviewcooperationuserlist(
    IN groupno integer,
    IN cooperationno integer
) RETURNS SETOF record
AS $function$
DECLARE
    tbuserno table
	(
		userno	int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	INSERT INTO tbUserNo
		RETURN QUERY
		select UserNo from WorkGroupAssistants where HistoryNo in(select HistoryNo from WorkGroups where GroupNo = work_getviewcooperationuserlist.groupno)
		UNION 
		RETURN QUERY
		select UserNo from WorkGroupHistorys where HistoryNo in(select HistoryNo from WorkGroups where GroupNo = work_getviewcooperationuserlist.groupno)
		UNION 
		RETURN QUERY
		select UserNo from WorkHistorys where HistoryNo in (select HistoryNo from Works where GroupNo = work_getviewcooperationuserlist.groupno)
		UNION 
		RETURN QUERY
		select UserNo from WorkAssistants where HistoryNo in (select HistoryNo from Works where GroupNo = work_getviewcooperationuserlist.groupno)		
		UNION 
		RETURN QUERY
		select UserNo from Work_CooperationReference where CooperationNo = work_getviewcooperationuserlist.cooperationno	
	
	
	RETURN QUERY
	select A.UserNo,UserID, A.Name AS UserName, D.Name AS PositionName , COALESCE(CONVERT(CHAR(23), WC.ReadDate, 21),'') as ReadDate from Organization_Users A
	JOIN tbUserNo B on A.UserNo = B.UserNo
	left JOIN Work_CooperationReference WC on A.Userno = WC.UserNo and WC.CooperationNo = work_getviewcooperationuserlist.cooperationno	
	INNER JOIN Organization_BelongToDepartment C ON C.UserNo = B.UserNo AND C.IsDefault = TRUE
	INNER JOIN Organization_Positions D ON D.PositionNo = C.PositionNo
	LEFT JOIN Organization_Duties E ON E.DutyNo = C.DutyNo
	where A.Enabled = TRUE
	order by D.SortNo, E.SortNo ,A.Name;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
