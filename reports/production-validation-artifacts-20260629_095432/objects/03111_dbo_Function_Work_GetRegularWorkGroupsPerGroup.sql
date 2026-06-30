-- ─── FUNCTION: work_getregularworkgroupspergroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getregularworkgroupspergroup(date, date, integer, integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.work_getregularworkgroupspergroup(
    startdate date,
    enddate date,
    divisionno integer,
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


	IF DivisionNo = 0 BEGIN
		
		IF SearchType = 0 BEGIN
		
			RETURN QUERY
			SELECT * FROM (
				SELECT CONVERT(INT, ROW_NUMBER() OVER (ORDER BY T.WorkTime DESC)) AS RowNum,
					RWG.GroupNo, RWGH.Name AS GroupName, D.Name AS DivisionName,
					U.Name AS UserName, P.Name AS PositionName,
					T.WorkTime, RWG.RegDate
				FROM (
					SELECT RWG.GroupNo, COALESCE(SUM(RWJ.WorkTime), 0) AS WorkTime
					FROM RegularWorkGroups RWG
					LEFT JOIN RegularWorkJournals RWJ ON RWJ.GroupNo = RWG.GroupNo
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
			WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			
		END
		
		ELSE IF SearchType = 1 BEGIN
		
			RETURN QUERY
			SELECT * FROM (
				SELECT CONVERT(INT, ROW_NUMBER() OVER (ORDER BY T.WorkTime DESC)) AS RowNum,
					RWG.GroupNo, RWGH.Name AS GroupName, D.Name AS DivisionName,
					U.Name AS UserName, P.Name AS PositionName,
					T.WorkTime, RWG.RegDate
				FROM (
					SELECT RWG.GroupNo, COALESCE(SUM(RWJ.WorkTime), 0) AS WorkTime
					FROM RegularWorkGroups RWG
					INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
					LEFT JOIN RegularWorkJournals RWJ ON RWJ.GroupNo = RWG.GroupNo
						AND (RWJ.CreationDate BETWEEN StartDate AND EndDate)
					WHERE RWG.Enabled = TRUE AND RWGH.Name ILIKE '%' || SearchText || '%'
					GROUP BY RWG.GroupNo
				) T
				INNER JOIN RegularWorkGroups RWG ON RWG.GroupNo = T.GroupNo
				INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
				INNER JOIN Organization_Users U ON U.UserNo = RWGH.UserNo
				INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWGH.UserNo and B.IsDefault = TRUE
				INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
				INNER JOIN RegularWorkGroupDivisions D ON D.DivisionNo = RWGH.DivisionNo
			) T
			WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			
		END
		
	END
	
	ELSE BEGIN
		
		IF SearchType = 0 BEGIN
		
			RETURN QUERY
			SELECT * FROM (
				SELECT CONVERT(INT, ROW_NUMBER() OVER (ORDER BY T.WorkTime DESC)) AS RowNum,
					RWG.GroupNo, RWGH.Name AS GroupName, D.Name AS DivisionName,
					U.Name AS UserName, P.Name AS PositionName,
					T.WorkTime, RWG.RegDate
				FROM (
					SELECT RWG.GroupNo, COALESCE(SUM(RWJ.WorkTime), 0) AS WorkTime
					FROM RegularWorkGroups RWG
					INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
						AND RWGH.DivisionNo = work_getregularworkgroupspergroup.divisionno
					LEFT JOIN RegularWorkJournals RWJ ON RWJ.GroupNo = RWG.GroupNo
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
			WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			
		END
		
		ELSE IF SearchType = 1 BEGIN
		
			RETURN QUERY
			SELECT * FROM (
				SELECT CONVERT(INT, ROW_NUMBER() OVER (ORDER BY T.WorkTime DESC)) AS RowNum,
					RWG.GroupNo, RWGH.Name AS GroupName, D.Name AS DivisionName,
					U.Name AS UserName, P.Name AS PositionName,
					T.WorkTime, RWG.RegDate
				FROM (
					SELECT RWG.GroupNo, COALESCE(SUM(RWJ.WorkTime), 0) AS WorkTime
					FROM RegularWorkGroups RWG
					INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
						AND RWGH.DivisionNo = work_getregularworkgroupspergroup.divisionno
					LEFT JOIN RegularWorkJournals RWJ ON RWJ.GroupNo = RWG.GroupNo
						AND (RWJ.CreationDate BETWEEN StartDate AND EndDate)
					WHERE RWG.Enabled = TRUE AND RWGH.Name ILIKE '%' || SearchText || '%'
					GROUP BY RWG.GroupNo
				) T
				INNER JOIN RegularWorkGroups RWG ON RWG.GroupNo = T.GroupNo
				INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
				INNER JOIN Organization_Users U ON U.UserNo = RWGH.UserNo
				INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWGH.UserNo and B.IsDefault = TRUE
				INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
				INNER JOIN RegularWorkGroupDivisions D ON D.DivisionNo = RWGH.DivisionNo
			) T
			WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			
		END
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
