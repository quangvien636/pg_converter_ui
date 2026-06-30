-- ─── FUNCTION: work_getallworkgroupsperuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getallworkgroupsperuser(integer, date, date, integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.work_getallworkgroupsperuser(
    userno integer,
    startdate date,
    enddate date,
    searchtype integer,
    searchtext character varying,
    viewcount integer,
    currentpageindex integer
) RETURNS TABLE(
    groupno text,
    worktime text
)
AS $function$
BEGIN


	IF SearchType = 0 BEGIN
	
		RETURN QUERY
		SELECT * FROM (
			SELECT CONVERT(INT, ROW_NUMBER() OVER (ORDER BY T.WorkTime DESC)) AS RowNum, *
			FROM (
				SELECT 0 AS IsRegular, WG.GroupNo, WGH.Name AS GroupName,
					U.Name AS UserName, P.Name AS PositionName, '-' AS DivisionName,
					WG.RegDate, WGH.CompleteDate, WorkTime
				FROM (
					SELECT WG.GroupNo, COALESCE(SUM(WJ.WorkTime), 0) AS WorkTime
					FROM WorkGroups WG
					INNER JOIN Works W ON W.GroupNo = WG.GroupNo
					INNER JOIN WorkJournals WJ ON WJ.WorkNo = W.WorkNo
						AND WJ.RegUserNo = work_getallworkgroupsperuser.userno
						AND (WJ.CreationDate BETWEEN StartDate AND EndDate)
					WHERE WG.Enabled = TRUE
					GROUP BY WG.GroupNo
				) T
				INNER JOIN WorkGroups WG ON WG.GroupNo = T.GroupNo
				INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
				INNER JOIN Organization_Users U ON U.UserNo = WGH.UserNo
				INNER JOIN Organization_BelongToDepartment B ON B.UserNo = WGH.UserNo and B.IsDefault = TRUE
				INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo

				UNION ALL
				SELECT 1, RWG.GroupNo, RWGH.Name AS GroupName,
					U.Name, P.Name, D.Name,
					 RWG.RegDate, NULL, T.WorkTime
				FROM (
					SELECT RWG.GroupNo, COALESCE(SUM(RWJ.WorkTime), 0) AS WorkTime
					FROM RegularWorkGroups RWG
					INNER JOIN RegularWorkJournals RWJ ON RWJ.GroupNo = RWG.GroupNo
						AND RWJ.RegUserNo = work_getallworkgroupsperuser.userno
						AND (RWJ.CreationDate BETWEEN StartDate AND EndDate)
					WHERE RWG.Enabled = TRUE
					GROUP BY RWG.GroupNo
				) T
				INNER JOIN RegularWorkGroups RWG ON RWG.GroupNo = T.GroupNo
				INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
				INNER JOIN Organization_Users U ON U.UserNo = RWGH.UserNo
				INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWGH.UserNo and B.IsDefault = TRUE
				INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
				INNER JOIN RegularWorkGroupDivisions D ON D.DivisionNo = RWGH.DivisionNo
			) T
		) T
		WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
		
	END
	
	ELSE IF SearchType = 1 BEGIN
	
		RETURN QUERY
		SELECT * FROM (
			SELECT CONVERT(INT, ROW_NUMBER() OVER (ORDER BY T.WorkTime DESC)) AS RowNum, *
			FROM (
				SELECT 0 AS IsRegular, WG.GroupNo, WGH.Name AS GroupName,
					U.Name AS UserName, P.Name AS PositionName, '-' AS DivisionName,
					WG.RegDate, WGH.CompleteDate, WorkTime
				FROM (
					SELECT WG.GroupNo, COALESCE(SUM(WJ.WorkTime), 0) AS WorkTime
					FROM WorkGroups WG
					INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
						AND WGH.Name ILIKE '%' || SearchText || '%'
					INNER JOIN Works W ON W.GroupNo = WG.GroupNo
					INNER JOIN WorkJournals WJ ON WJ.WorkNo = W.WorkNo
						AND WJ.RegUserNo = work_getallworkgroupsperuser.userno
						AND (WJ.CreationDate BETWEEN StartDate AND EndDate)
					WHERE WG.Enabled = TRUE
					GROUP BY WG.GroupNo
				) T
				INNER JOIN WorkGroups WG ON WG.GroupNo = T.GroupNo
				INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
				INNER JOIN Organization_Users U ON U.UserNo = WGH.UserNo
				INNER JOIN Organization_BelongToDepartment B ON B.UserNo = WGH.UserNo and B.IsDefault = TRUE
				INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo

				UNION ALL
				SELECT 1, RWG.GroupNo, RWGH.Name AS GroupName,
					U.Name, P.Name, D.Name,
					 RWG.RegDate, NULL, T.WorkTime
				FROM (
					SELECT RWG.GroupNo, COALESCE(SUM(RWJ.WorkTime), 0) AS WorkTime
					FROM RegularWorkGroups RWG
					INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
						AND RWGH.Name ILIKE '%' || SearchText || '%'
					INNER JOIN RegularWorkJournals RWJ ON RWJ.GroupNo = RWG.GroupNo
						AND RWJ.RegUserNo = work_getallworkgroupsperuser.userno
						AND (RWJ.CreationDate BETWEEN StartDate AND EndDate)
					WHERE RWG.Enabled = TRUE
					GROUP BY RWG.GroupNo
				) T
				INNER JOIN RegularWorkGroups RWG ON RWG.GroupNo = T.GroupNo
				INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
				INNER JOIN Organization_Users U ON U.UserNo = RWGH.UserNo
				INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWGH.UserNo and B.IsDefault = TRUE
				INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
				INNER JOIN RegularWorkGroupDivisions D ON D.DivisionNo = RWGH.DivisionNo
			) T
		) T
		WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
