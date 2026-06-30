-- ─── PROCEDURE→FUNCTION: work_getregularworkgroups ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getregularworkgroups(integer, integer, integer, character varying, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.work_getregularworkgroups(
    IN userno integer,
    IN divisionno integer,
    IN searchtype integer,
    IN searchtext character varying,
    IN viewcount integer,
    IN currentpageindex integer,
    IN ismanager boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF IsManager = TRUE THEN
	
		IF DivisionNo = 0 THEN
		
			IF SearchType = 0 THEN
		
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
		
			END IF;
			
			ELSIF SearchType = 1 THEN
			
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
		
			END IF;
		
		END IF;
		
		ELSE BEGIN
		
			IF SearchType = 0 THEN
		
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
		
			END IF;
			
			ELSIF SearchType = 1 THEN
			
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
		
			END IF;
			
		END IF;
		
	END;

	ELSIF IsDirector = TRUE THEN
	
		IF DivisionNo = 0 THEN
	
			IF SearchType = 0 THEN
		
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
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
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
				
			END IF;
		
		END IF;
		
		ELSE BEGIN
		
			IF SearchType = 0 THEN
		
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
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
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
				
			END IF;
			
		END IF;
		
	END;
	
	ELSIF IsPerson = TRUE THEN
	
		IF DivisionNo = 0 THEN
	
			IF SearchType = 0 THEN
		
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
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
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
				
			END IF;
		
		END IF;
		
		ELSE BEGIN
		
			IF SearchType = 0 THEN
		
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
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
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
				
			END IF;
		
		END IF;
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
