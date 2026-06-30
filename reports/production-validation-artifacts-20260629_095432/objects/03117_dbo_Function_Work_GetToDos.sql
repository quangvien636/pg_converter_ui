-- ─── FUNCTION: work_gettodos ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_gettodos(integer, integer, integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.work_gettodos(
    userno integer,
    divisionno integer,
    searchtype integer,
    searchtext character varying,
    viewcount integer,
    currentpageindex integer
) RETURNS TABLE(
    userno text
)
AS $function$
BEGIN


	IF DivisionNo = 0 BEGIN
		
		IF SearchType = 0 BEGIN
		
			RETURN QUERY
			SELECT * FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY WH.CompleteDate ASC) AS RowNum,
					W.WorkNo, WGH.Name AS GroupName, WD.Name AS DivisionName, WH.Title,
					U.Name AS UserName, P.Name AS PositionName,
					W.RegDate, WH.CompleteDate, WH.WorkTime, W.CompletionRate, W.FinalDate
				FROM Works W
				INNER JOIN WorkGroups WG ON WG.GroupNo = W.GroupNo AND WG.Enabled = TRUE AND WG.State = 2
				INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
				INNER JOIN WorkHistorys WH ON WH.HistoryNo = W.HistoryNo
					AND (WH.UserNo = work_gettodos.userno OR W.HistoryNo IN (SELECT HistoryNo FROM WorkAssistants
															    WHERE UserNo = work_gettodos.userno)
						OR (WH.IsEveryPerson = TRUE AND UserNo IN (SELECT UserNo FROM WorkGroupPersons
		                                                         WHERE GroupNo = WG.GroupNo))
		            )
				INNER JOIN WorkDivisions WD ON WD.DivisionNo = WH.DivisionNo
				INNER JOIN Organization_Users U ON U.UserNo = WGH.UserNo
				INNER JOIN Organization_BelongToDepartment B ON B.UserNo = WGH.UserNo and B.IsDefault = TRUE
				INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
				WHERE W.Enabled = TRUE AND W.FinalDate IS NULL
			) AS T
			WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
				AND CurrentPageIndex * ViewCount
			
		END
		
		ELSE IF SearchType = 1 BEGIN
		
			RETURN QUERY
			SELECT * FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY WH.CompleteDate ASC) AS RowNum,
					W.WorkNo, WGH.Name AS GroupName, WD.Name AS DivisionName, WH.Title,
					U.Name AS UserName, P.Name AS PositionName,
					W.RegDate, WH.CompleteDate, WH.WorkTime, W.CompletionRate, W.FinalDate
				FROM Works W
				INNER JOIN WorkGroups WG ON WG.GroupNo = W.GroupNo AND WG.Enabled = TRUE AND WG.State = 2
				INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
				INNER JOIN WorkHistorys WH ON WH.HistoryNo = W.HistoryNo
					AND (WH.UserNo = work_gettodos.userno OR W.HistoryNo IN (SELECT HistoryNo FROM WorkAssistants
															    WHERE UserNo = work_gettodos.userno)
						OR (WH.IsEveryPerson = TRUE AND UserNo IN (SELECT UserNo FROM WorkGroupPersons
		                                                         WHERE GroupNo = WG.GroupNo))
		            )
					AND WH.Title ILIKE '%' || SearchText || '%'
				INNER JOIN WorkDivisions WD ON WD.DivisionNo = WH.DivisionNo
				INNER JOIN Organization_Users U ON U.UserNo = WGH.RegUserNo
				INNER JOIN Organization_BelongToDepartment B ON B.UserNo = WGH.RegUserNo and B.IsDefault = TRUE
				INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
				WHERE W.Enabled = TRUE AND W.FinalDate IS NULL
			) AS T
			WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
				AND CurrentPageIndex * ViewCount
			
		END
		
	END
	
	ELSE BEGIN
		
		IF SearchType = 0 BEGIN
		
			RETURN QUERY
			SELECT * FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY WH.CompleteDate ASC) AS RowNum,
					W.WorkNo, WGH.Name AS GroupName, WD.Name AS DivisionName, WH.Title,
					U.Name AS UserName, P.Name AS PositionName,
					W.RegDate, WH.CompleteDate, WH.WorkTime, W.CompletionRate, W.FinalDate
				FROM Works W
				INNER JOIN WorkGroups WG ON WG.GroupNo = W.GroupNo AND WG.Enabled = TRUE AND WG.State = 2
				INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
				INNER JOIN WorkHistorys WH ON WH.HistoryNo = W.HistoryNo
					AND WH.DivisionNo = work_gettodos.divisionno
					AND (WH.UserNo = work_gettodos.userno OR W.HistoryNo IN (SELECT HistoryNo FROM WorkAssistants
															    WHERE UserNo = work_gettodos.userno)
						OR (WH.IsEveryPerson = TRUE AND UserNo IN (SELECT UserNo FROM WorkGroupPersons
		                                                         WHERE GroupNo = WG.GroupNo))
		            )
				INNER JOIN WorkDivisions WD ON WD.DivisionNo = WH.DivisionNo
				INNER JOIN Organization_Users U ON U.UserNo = W.RegUserNo
				INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo and B.IsDefault = TRUE
				INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
				WHERE W.Enabled = TRUE AND W.FinalDate IS NULL
			) AS T
			WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
				AND CurrentPageIndex * ViewCount
			
		END
		
		ELSE IF SearchType = 1 BEGIN
		
			RETURN QUERY
			SELECT * FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY WH.CompleteDate ASC) AS RowNum,
					W.WorkNo, WGH.Name AS GroupName, WD.Name AS DivisionName, WH.Title,
					U.Name AS UserName, P.Name AS PositionName,
					W.RegDate, WH.CompleteDate, WH.WorkTime, W.CompletionRate, W.FinalDate
				FROM Works W
				INNER JOIN WorkGroups WG ON WG.GroupNo = W.GroupNo AND WG.Enabled = TRUE AND WG.State = 2
				INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
				INNER JOIN WorkHistorys WH ON WH.HistoryNo = W.HistoryNo
					AND WH.DivisionNo = work_gettodos.divisionno
					AND (WH.UserNo = work_gettodos.userno OR W.HistoryNo IN (SELECT HistoryNo FROM WorkAssistants
															    WHERE UserNo = work_gettodos.userno)
						OR (WH.IsEveryPerson = TRUE AND UserNo IN (SELECT UserNo FROM WorkGroupPersons
		                                                         WHERE GroupNo = WG.GroupNo))
		            )																	
					AND WH.Title ILIKE '%' || SearchText || '%'
				INNER JOIN WorkDivisions WD ON WD.DivisionNo = WH.DivisionNo
				INNER JOIN Organization_Users U ON U.UserNo = WH.UserNo
				INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo and B.IsDefault = TRUE
				INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
				WHERE W.Enabled = TRUE AND W.FinalDate IS NULL
			) AS T
			WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
				AND CurrentPageIndex * ViewCount
			
		END
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
