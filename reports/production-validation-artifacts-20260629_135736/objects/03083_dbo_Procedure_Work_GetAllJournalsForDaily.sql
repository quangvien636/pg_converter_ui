-- ─── PROCEDURE→FUNCTION: work_getalljournalsfordaily ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getalljournalsfordaily(integer, date, date);
CREATE OR REPLACE FUNCTION public.work_getalljournalsfordaily(
    IN userno integer,
    IN startdate date,
    IN enddate date
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF UserNo = 0 THEN

		RETURN QUERY
		SELECT * FROM (
			SELECT 0 AS IsRegular, WJ.JournalNo, WJ.WorkNo AS GroupNo, WJ.CreationDate,
				WGH.Name AS GroupName, WH.Title AS WorkTitle,
				WD.Name AS DivisionName, WH.Title, WJ.Content,
				U.UserNo, U.Name AS UserName, P.Name AS PositionName,
				WJ.WorkTime, WJ.CompletionRate, WJ.ModDate
			FROM WorkJournals WJ
			INNER JOIN Works W ON W.WorkNo = WJ.WorkNo
			INNER JOIN WorkHistorys WH ON WH.HistoryNo = W.HistoryNo
			INNER JOIN WorkDivisions WD ON WD.DivisionNo = WH.DivisionNo
			INNER JOIN WorkGroups WG ON WG.GroupNo = W.GroupNo
			INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
			INNER JOIN Organization_Users U ON U.UserNo = WJ.RegUserNo
			INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo and B.IsDefault = TRUE
			INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
			WHERE WG.Enabled = TRUE AND (WJ.CreationDate BETWEEN StartDate AND EndDate)

			UNION ALL
			SELECT 1, RWJ.JournalNo, RWG.GroupNo, RWJ.CreationDate,
				RWGH.Name, RWJ.Title,
				D.Name, RWJ.Title, RWJ.Content,
				U.UserNo, U.Name, P.Name,
				RWJ.WorkTime, 0, RWJ.ModDate
			FROM RegularWorkJournals RWJ
			INNER JOIN RegularWorkGroups RWG ON RWG.GroupNo = RWJ.GroupNo
			INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
			INNER JOIN RegularWorkJournalDivisions D ON D.DivisionNo = RWJ.DivisionNo
			INNER JOIN Organization_Users U ON U.UserNo = RWJ.RegUserNo
			INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWJ.RegUserNo and B.IsDefault = TRUE
			INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
			WHERE RWG.Enabled = TRUE AND (RWJ.CreationDate BETWEEN StartDate AND EndDate)
		) W
		ORDER BY W.UserName ASC, W.UserNo ASC, W.ModDate DESC
	
	END IF;
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT * FROM (
			SELECT 0 AS IsRegular, WJ.JournalNo, WJ.WorkNo AS GroupNo, WJ.CreationDate,
				WGH.Name AS GroupName, WH.Title AS WorkTitle,
				WD.Name AS DivisionName, WH.Title, WJ.Content,
				U.UserNo, U.Name AS UserName, P.Name AS PositionName,
				WJ.WorkTime, WJ.CompletionRate, WJ.ModDate
			FROM WorkJournals WJ
			INNER JOIN Works W ON W.WorkNo = WJ.WorkNo
			INNER JOIN WorkHistorys WH ON WH.HistoryNo = W.HistoryNo
			INNER JOIN WorkDivisions WD ON WD.DivisionNo = WH.DivisionNo
			INNER JOIN WorkGroups WG ON WG.GroupNo = W.GroupNo
			INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
			INNER JOIN Organization_Users U ON U.UserNo = WJ.RegUserNo
			INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo and B.IsDefault = TRUE
			INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
			WHERE WG.Enabled = TRUE AND WJ.RegUserNo = work_getalljournalsfordaily.userno
				AND (WJ.CreationDate BETWEEN StartDate AND EndDate)

			UNION ALL
			SELECT 1, RWJ.JournalNo, RWG.GroupNo, RWJ.CreationDate,
				RWGH.Name, RWJ.Title,
				D.Name, RWJ.Title, RWJ.Content,
				U.UserNo, U.Name, P.Name,
				RWJ.WorkTime, 0, RWJ.ModDate
			FROM RegularWorkJournals RWJ
			INNER JOIN RegularWorkGroups RWG ON RWG.GroupNo = RWJ.GroupNo
			INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
			INNER JOIN RegularWorkJournalDivisions D ON D.DivisionNo = RWJ.DivisionNo
			INNER JOIN Organization_Users U ON U.UserNo = RWJ.RegUserNo
			INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWJ.RegUserNo and B.IsDefault = TRUE
			INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
			WHERE RWG.Enabled = TRUE AND RWJ.RegUserNo = work_getalljournalsfordaily.userno
				AND (RWJ.CreationDate BETWEEN StartDate AND EndDate)
		) W
		ORDER BY W.CreationDate ASC, W.ModDate DESC
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
