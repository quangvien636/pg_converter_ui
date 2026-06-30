-- ─── FUNCTION: work_getregularworkgroups ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getregularworkgroups(integer, integer, integer, character varying, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.work_getregularworkgroups(
    userno integer,
    divisionno integer,
    searchtype integer,
    searchtext character varying,
    viewcount integer,
    currentpageindex integer,
    ismanager boolean
) RETURNS TABLE(
    historyno text
)
AS $function$
BEGIN


	IF IsManager = TRUE BEGIN
	
		IF DivisionNo = 0 BEGIN
		
			IF SearchType = 0 BEGIN
		
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY W.RegDate DESC) AS RowNum,
						W.GroupNo, H.Name AS GroupName, D.Name AS DivisionName,
						U.Name AS UserName, P.Name AS PositionName,
						W.RegDate, H.RegDate AS ModDate, W.Enabled
					FROM RegularWorkGroups W
					INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
					INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					INNER JOIN RegularWorkGroupDivisions D ON D.DivisionNo = H.DivisionNo
					WHERE W.Enabled = TRUE
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
		
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY W.RegDate DESC) AS RowNum,
						W.GroupNo, H.Name AS GroupName, D.Name AS DivisionName,
						U.Name AS UserName, P.Name AS PositionName,
						W.RegDate, H.RegDate AS ModDate, W.Enabled
					FROM RegularWorkGroups W
					INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
					INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					INNER JOIN RegularWorkGroupDivisions D ON D.DivisionNo = H.DivisionNo
					WHERE W.Enabled = TRUE AND H.Name ILIKE '%' || SearchText || '%'
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
		
			END
		
		END
		
		ELSE BEGIN
		
			IF SearchType = 0 BEGIN
		
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY W.RegDate DESC) AS RowNum,
						W.GroupNo, H.Name AS GroupName, D.Name AS DivisionName,
						U.Name AS UserName, P.Name AS PositionName,
						W.RegDate, H.RegDate AS ModDate, W.Enabled
					FROM RegularWorkGroups W
					INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
						 AND H.DivisionNo = work_getregularworkgroups.divisionno
					INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					INNER JOIN RegularWorkGroupDivisions D ON D.DivisionNo = H.DivisionNo
					WHERE W.Enabled = TRUE
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
		
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY W.RegDate DESC) AS RowNum,
						W.GroupNo, H.Name AS GroupName, D.Name AS DivisionName,
						U.Name AS UserName, P.Name AS PositionName,
						W.RegDate, H.RegDate AS ModDate, W.Enabled
					FROM RegularWorkGroups W
					INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
						AND H.DivisionNo = work_getregularworkgroups.divisionno AND H.Name ILIKE '%' || SearchText || '%'
					INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					INNER JOIN RegularWorkGroupDivisions D ON D.DivisionNo = H.DivisionNo
					WHERE W.Enabled = TRUE
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
		
			END
			
		END
		
	END

	ELSE IF IsDirector = TRUE BEGIN
	
		IF DivisionNo = 0 BEGIN
	
			IF SearchType = 0 BEGIN
		
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY W.RegDate DESC) AS RowNum,
						W.GroupNo, H.Name AS GroupName, D.Name AS DivisionName,
						U.Name AS UserName, P.Name AS PositionName,
						W.RegDate, H.RegDate AS ModDate, W.Enabled
					FROM RegularWorkGroups W
					INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
						 AND H.UserNo = work_getregularworkgroups.userno
					INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					INNER JOIN RegularWorkGroupDivisions D ON D.DivisionNo = H.DivisionNo
					WHERE W.Enabled = TRUE
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY W.RegDate DESC) AS RowNum,
						W.GroupNo, H.Name AS GroupName, D.Name AS DivisionName,
						U.Name AS UserName, P.Name AS PositionName,
						W.RegDate, H.RegDate AS ModDate, W.Enabled
					FROM RegularWorkGroups W
					INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
						AND H.UserNo = work_getregularworkgroups.userno AND H.Name ILIKE '%' || SearchText || '%'
					INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					INNER JOIN RegularWorkGroupDivisions D ON D.DivisionNo = H.DivisionNo
					WHERE W.Enabled = TRUE
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
				
			END
		
		END
		
		ELSE BEGIN
		
			IF SearchType = 0 BEGIN
		
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY W.RegDate DESC) AS RowNum,
						W.GroupNo, H.Name AS GroupName, D.Name AS DivisionName,
						U.Name AS UserName, P.Name AS PositionName,
						W.RegDate, H.RegDate AS ModDate, W.Enabled
					FROM RegularWorkGroups W
					INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
						AND H.UserNo = work_getregularworkgroups.userno AND H.DivisionNo = work_getregularworkgroups.divisionno
					INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					INNER JOIN RegularWorkGroupDivisions D ON D.DivisionNo = H.DivisionNo
					WHERE W.Enabled = TRUE
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY W.RegDate DESC) AS RowNum,
						W.GroupNo, H.Name AS GroupName, D.Name AS DivisionName,
						U.Name AS UserName, P.Name AS PositionName,
						W.RegDate, H.RegDate AS ModDate, W.Enabled
					FROM RegularWorkGroups W
					INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
						AND H.UserNo = work_getregularworkgroups.userno AND H.DivisionNo = work_getregularworkgroups.divisionno
						AND H.Name ILIKE '%' || SearchText || '%'
					INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					INNER JOIN RegularWorkGroupDivisions D ON D.DivisionNo = H.DivisionNo
					WHERE W.Enabled = TRUE
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
				
			END
			
		END
		
	END
	
	ELSE IF IsPerson = TRUE BEGIN
	
		IF DivisionNo = 0 BEGIN
	
			IF SearchType = 0 BEGIN
		
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY W.RegDate DESC) AS RowNum,
						W.GroupNo, H.Name AS GroupName, D.Name AS DivisionName,
						U.Name AS UserName, P.Name AS PositionName,
						W.RegDate, H.RegDate AS ModDate, W.Enabled
					FROM RegularWorkGroups W
					INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
						AND (H.IsEveryPerson = TRUE OR H.HistoryNo IN (
							SELECT HistoryNo FROM RegularWorkGroupPersons WHERE UserNo = work_getregularworkgroups.userno))
					INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					INNER JOIN RegularWorkGroupDivisions D ON D.DivisionNo = H.DivisionNo
					WHERE W.Enabled = TRUE
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY W.RegDate DESC) AS RowNum,
						W.GroupNo, H.Name AS GroupName, D.Name AS DivisionName,
						U.Name AS UserName, P.Name AS PositionName,
						W.RegDate, H.RegDate AS ModDate, W.Enabled
					FROM RegularWorkGroups W
					INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
						AND (H.IsEveryPerson = TRUE OR H.HistoryNo IN (
							SELECT HistoryNo FROM RegularWorkGroupPersons WHERE UserNo = work_getregularworkgroups.userno))
						AND H.Name ILIKE '%' || SearchText || '%'
					INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					INNER JOIN RegularWorkGroupDivisions D ON D.DivisionNo = H.DivisionNo
					WHERE W.Enabled = TRUE
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
				
			END
		
		END
		
		ELSE BEGIN
		
			IF SearchType = 0 BEGIN
		
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY W.RegDate DESC) AS RowNum,
						W.GroupNo, H.Name AS GroupName, D.Name AS DivisionName,
						U.Name AS UserName, P.Name AS PositionName,
						W.RegDate, H.RegDate AS ModDate, W.Enabled
					FROM RegularWorkGroups W
					INNER JOIN RegularWorkGroupPersons RWGP ON RWGP.UserNo = work_getregularworkgroups.userno
						AND RWGP.HistoryNo = W.HistoryNo
					INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
						AND (H.IsEveryPerson = TRUE OR H.HistoryNo IN (
							SELECT HistoryNo FROM RegularWorkGroupPersons WHERE UserNo = work_getregularworkgroups.userno))
						AND H.DivisionNo = work_getregularworkgroups.divisionno
					INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					INNER JOIN RegularWorkGroupDivisions D ON D.DivisionNo = H.DivisionNo
					WHERE W.Enabled = TRUE
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY W.RegDate DESC) AS RowNum,
						W.GroupNo, H.Name AS GroupName, D.Name AS DivisionName,
						U.Name AS UserName, P.Name AS PositionName,
						W.RegDate, H.RegDate AS ModDate, W.Enabled
					FROM RegularWorkGroups W
					INNER JOIN RegularWorkGroupPersons RWGP ON RWGP.UserNo = work_getregularworkgroups.userno
						AND RWGP.HistoryNo = W.HistoryNo
					INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
						AND (H.IsEveryPerson = TRUE OR H.HistoryNo IN (
							SELECT HistoryNo FROM RegularWorkGroupPersons WHERE UserNo = work_getregularworkgroups.userno))
						AND H.DivisionNo = work_getregularworkgroups.divisionno AND H.Name ILIKE '%' || SearchText || '%'
					INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					INNER JOIN RegularWorkGroupDivisions D ON D.DivisionNo = H.DivisionNo
					WHERE W.Enabled = TRUE
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
				
			END
		
		END
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
