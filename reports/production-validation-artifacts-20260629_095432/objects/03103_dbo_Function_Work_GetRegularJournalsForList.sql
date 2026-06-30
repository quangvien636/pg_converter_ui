-- ─── FUNCTION: work_getregularjournalsforlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getregularjournalsforlist(integer, integer, integer, integer, character varying, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.work_getregularjournalsforlist(
    userno integer,
    groupno integer,
    divisionno integer,
    searchtype integer,
    searchtext character varying,
    viewcount integer,
    currentpageindex integer,
    ismanager boolean
) RETURNS TABLE(
    rownum text,
    journalno text,
    divisionname text,
    creationdate text,
    title text,
    reguserno text,
    username text,
    positionname text,
    worktime text
)
AS $function$
BEGIN


	IF IsManager = TRUE BEGIN
		
		IF DivisionNo = 0 BEGIN
		
			IF SearchType = 0 BEGIN
			
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
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
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
				
			END
		
		END
		
		ELSE BEGIN
		
			IF SearchType = 0 BEGIN
			
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
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
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
				
			END
		
		END
	
	END

	ELSE IF IsDirector = TRUE BEGIN
		
		IF DivisionNo = 0 BEGIN
		
			IF SearchType = 0 BEGIN
			
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
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
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
				
			END
		
		END
		
		ELSE BEGIN
		
			IF SearchType = 0 BEGIN
			
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
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
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
				
			END
		
		END
	
	END
	
	ELSE IF IsPerson = TRUE BEGIN
		
		IF DivisionNo = 0 BEGIN
		
			IF SearchType = 0 BEGIN
			
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
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
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
				
			END
		
		END
		
		ELSE BEGIN
		
			IF SearchType = 0 BEGIN
			
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
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
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
				
			END
		
		END
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
