-- ─── PROCEDURE→FUNCTION: work_getregularjournalsforlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getregularjournalsforlist(integer, integer, integer, integer, character varying, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.work_getregularjournalsforlist(
    IN userno integer,
    IN groupno integer,
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
					SELECT ROW_NUMBER() OVER (ORDER BY RWJ.CreationDate DESC, RWJ.JournalNo DESC) AS RowNum,
						RWJ.JournalNo, D.Name AS DivisionName, RWJ.CreationDate, RWJ.Title,
						RWJ.RegUserNo, U.Name AS UserName, P.Name AS PositionName, RWJ.WorkTime
					FROM RegularWorkJournals RWJ
					INNER JOIN RegularWorkJournalDivisions D ON D.DivisionNo = RWJ.DivisionNo
					INNER JOIN Organization_Users U ON U.UserNo = RWJ.RegUserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWJ.RegUserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					WHERE RWJ.GroupNo = work_getregularjournalsforlist.groupno
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY RWJ.CreationDate DESC, RWJ.JournalNo DESC) AS RowNum,
						RWJ.JournalNo, D.Name AS DivisionName, RWJ.CreationDate, RWJ.Title,
						RWJ.RegUserNo, U.Name AS UserName, P.Name AS PositionName, RWJ.WorkTime
					FROM RegularWorkJournals RWJ
					INNER JOIN RegularWorkJournalDivisions D ON D.DivisionNo = RWJ.DivisionNo
					INNER JOIN Organization_Users U ON U.UserNo = RWJ.RegUserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWJ.RegUserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					WHERE RWJ.GroupNo = work_getregularjournalsforlist.groupno AND Title ILIKE '%' || SearchText || '%'
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
				
			END IF;
		
		END IF;
		
		ELSE BEGIN
		
			IF SearchType = 0 THEN
			
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY RWJ.CreationDate DESC, RWJ.JournalNo DESC) AS RowNum,
						RWJ.JournalNo, D.Name AS DivisionName, RWJ.CreationDate, RWJ.Title,
						RWJ.RegUserNo, U.Name AS UserName, P.Name AS PositionName, RWJ.WorkTime
					FROM RegularWorkJournals RWJ
					INNER JOIN RegularWorkJournalDivisions D ON D.DivisionNo = RWJ.DivisionNo
					INNER JOIN Organization_Users U ON U.UserNo = RWJ.RegUserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWJ.RegUserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					WHERE RWJ.GroupNo = work_getregularjournalsforlist.groupno AND RWJ.DivisionNo = work_getregularjournalsforlist.divisionno
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY RWJ.CreationDate DESC, RWJ.JournalNo DESC) AS RowNum,
						RWJ.JournalNo, D.Name AS DivisionName, RWJ.CreationDate, RWJ.Title,
						RWJ.RegUserNo, U.Name AS UserName, P.Name AS PositionName, RWJ.WorkTime
					FROM RegularWorkJournals RWJ
					INNER JOIN RegularWorkJournalDivisions D ON D.DivisionNo = RWJ.DivisionNo
					INNER JOIN Organization_Users U ON U.UserNo = RWJ.RegUserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWJ.RegUserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					WHERE RWJ.GroupNo = work_getregularjournalsforlist.groupno AND RWJ.DivisionNo = work_getregularjournalsforlist.divisionno
						AND Title ILIKE '%' || SearchText || '%'
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
					SELECT ROW_NUMBER() OVER (ORDER BY RWJ.CreationDate DESC, RWJ.JournalNo DESC) AS RowNum,
						RWJ.JournalNo, D.Name AS DivisionName, RWJ.CreationDate, RWJ.Title,
						RWJ.RegUserNo, U.Name AS UserName, P.Name AS PositionName, RWJ.WorkTime
					FROM RegularWorkJournals RWJ
					INNER JOIN RegularWorkJournalDivisions D ON D.DivisionNo = RWJ.DivisionNo
					INNER JOIN Organization_Users U ON U.UserNo = RWJ.RegUserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWJ.RegUserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					WHERE RWJ.GroupNo = work_getregularjournalsforlist.groupno
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY RWJ.CreationDate DESC, RWJ.JournalNo DESC) AS RowNum,
						RWJ.JournalNo, D.Name AS DivisionName, RWJ.CreationDate, RWJ.Title,
						RWJ.RegUserNo, U.Name AS UserName, P.Name AS PositionName, RWJ.WorkTime
					FROM RegularWorkJournals RWJ
					INNER JOIN RegularWorkJournalDivisions D ON D.DivisionNo = RWJ.DivisionNo
					INNER JOIN Organization_Users U ON U.UserNo = RWJ.RegUserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWJ.RegUserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					WHERE RWJ.GroupNo = work_getregularjournalsforlist.groupno AND Title ILIKE '%' || SearchText || '%'
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
				
			END IF;
		
		END IF;
		
		ELSE BEGIN
		
			IF SearchType = 0 THEN
			
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY RWJ.CreationDate DESC, RWJ.JournalNo DESC) AS RowNum,
						RWJ.JournalNo, D.Name AS DivisionName, RWJ.CreationDate, RWJ.Title,
						RWJ.RegUserNo, U.Name AS UserName, P.Name AS PositionName, RWJ.WorkTime
					FROM RegularWorkJournals RWJ
					INNER JOIN RegularWorkJournalDivisions D ON D.DivisionNo = RWJ.DivisionNo
					INNER JOIN Organization_Users U ON U.UserNo = RWJ.RegUserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWJ.RegUserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					WHERE RWJ.GroupNo = work_getregularjournalsforlist.groupno AND RWJ.DivisionNo = work_getregularjournalsforlist.divisionno
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY RWJ.CreationDate DESC, RWJ.JournalNo DESC) AS RowNum,
						RWJ.JournalNo, D.Name AS DivisionName, RWJ.CreationDate, RWJ.Title,
						RWJ.RegUserNo, U.Name AS UserName, P.Name AS PositionName, RWJ.WorkTime
					FROM RegularWorkJournals RWJ
					INNER JOIN RegularWorkJournalDivisions D ON D.DivisionNo = RWJ.DivisionNo
					INNER JOIN Organization_Users U ON U.UserNo = RWJ.RegUserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWJ.RegUserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					WHERE RWJ.GroupNo = work_getregularjournalsforlist.groupno AND RWJ.DivisionNo = work_getregularjournalsforlist.divisionno
						AND Title ILIKE '%' || SearchText || '%'
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
					SELECT ROW_NUMBER() OVER (ORDER BY RWJ.CreationDate DESC, RWJ.JournalNo DESC) AS RowNum,
						RWJ.JournalNo, D.Name AS DivisionName, RWJ.CreationDate, RWJ.Title,
						RWJ.RegUserNo, U.Name AS UserName, P.Name AS PositionName, RWJ.WorkTime
					FROM RegularWorkJournals RWJ
					INNER JOIN RegularWorkJournalDivisions D ON D.DivisionNo = RWJ.DivisionNo
					INNER JOIN Organization_Users U ON U.UserNo = RWJ.RegUserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWJ.RegUserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					WHERE RWJ.RegUserNo = work_getregularjournalsforlist.userno AND RWJ.GroupNo = work_getregularjournalsforlist.groupno
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY RWJ.CreationDate DESC, RWJ.JournalNo DESC) AS RowNum,
						RWJ.JournalNo, D.Name AS DivisionName, RWJ.CreationDate, RWJ.Title,
						RWJ.RegUserNo, U.Name AS UserName, P.Name AS PositionName, RWJ.WorkTime
					FROM RegularWorkJournals RWJ
					INNER JOIN RegularWorkJournalDivisions D ON D.DivisionNo = RWJ.DivisionNo
					INNER JOIN Organization_Users U ON U.UserNo = RWJ.RegUserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWJ.RegUserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					WHERE RWJ.RegUserNo = work_getregularjournalsforlist.userno AND RWJ.GroupNo = work_getregularjournalsforlist.groupno AND Title ILIKE '%' || SearchText || '%'
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
				
			END IF;
		
		END IF;
		
		ELSE BEGIN
		
			IF SearchType = 0 THEN
			
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY RWJ.CreationDate DESC, RWJ.JournalNo DESC) AS RowNum,
						RWJ.JournalNo, D.Name AS DivisionName, RWJ.CreationDate, RWJ.Title,
						RWJ.RegUserNo, U.Name AS UserName, P.Name AS PositionName, RWJ.WorkTime
					FROM RegularWorkJournals RWJ
					INNER JOIN RegularWorkJournalDivisions D ON D.DivisionNo = RWJ.DivisionNo
					INNER JOIN Organization_Users U ON U.UserNo = RWJ.RegUserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWJ.RegUserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					WHERE RWJ.RegUserNo = work_getregularjournalsforlist.userno AND RWJ.GroupNo = work_getregularjournalsforlist.groupno AND RWJ.DivisionNo = work_getregularjournalsforlist.divisionno
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
				RETURN QUERY
				SELECT * FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY RWJ.CreationDate DESC, RWJ.JournalNo DESC) AS RowNum,
						RWJ.JournalNo, D.Name AS DivisionName, RWJ.CreationDate, RWJ.Title,
						RWJ.RegUserNo, U.Name AS UserName, P.Name AS PositionName, RWJ.WorkTime
					FROM RegularWorkJournals RWJ
					INNER JOIN RegularWorkJournalDivisions D ON D.DivisionNo = RWJ.DivisionNo
					INNER JOIN Organization_Users U ON U.UserNo = RWJ.RegUserNo
					INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWJ.RegUserNo and B.IsDefault = TRUE
					INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
					WHERE RWJ.RegUserNo = work_getregularjournalsforlist.userno AND RWJ.GroupNo = work_getregularjournalsforlist.groupno AND RWJ.DivisionNo = work_getregularjournalsforlist.divisionno
						AND Title ILIKE '%' || SearchText || '%'
				) AS T
				WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
				
			END IF;
		
		END IF;
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
