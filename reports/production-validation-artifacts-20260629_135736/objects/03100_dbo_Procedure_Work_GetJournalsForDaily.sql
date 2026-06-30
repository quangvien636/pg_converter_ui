-- ─── PROCEDURE→FUNCTION: work_getjournalsfordaily ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getjournalsfordaily(integer, date);
CREATE OR REPLACE FUNCTION public.work_getjournalsfordaily(
    IN userno integer,
    IN startdate date
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT * FROM (
		SELECT 0 AS IsRegular, WJ.JournalNo, WJ.WorkNo AS GroupNo, WGH.Name AS GroupName,
			WD.Name AS DivisionName, WH.Title,
			U.Name AS UserName, P.Name AS PositionName,
			WJ.WorkTime, WJ.CompletionRate, WJ.ModDate
		FROM WorkJournals WJ
		INNER JOIN Works W ON W.WorkNo = WJ.WorkNo
		INNER JOIN WorkHistorys WH ON WH.HistoryNo = W.HistoryNo
		INNER JOIN WorkDivisions WD ON WD.DivisionNo = WH.DivisionNo
		INNER JOIN WorkGroups WG ON WG.GroupNo = W.GroupNo
		INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
		INNER JOIN Organization_Users U ON U.UserNo = WGH.UserNo
		INNER JOIN Organization_BelongToDepartment B ON B.UserNo = WGH.UserNo and B.IsDefault = TRUE
		INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		WHERE WG.Enabled = TRUE AND WJ.RegUserNo = work_getjournalsfordaily.userno
			AND (WJ.CreationDate BETWEEN StartDate AND StartDate)

		UNION ALL
		SELECT 1, RWJ.JournalNo, RWG.GroupNo, RWGH.Name,
			D.Name, RWJ.Title,
			U.Name, P.Name,
			RWJ.WorkTime, 0, RWJ.ModDate
		FROM RegularWorkJournals RWJ
		INNER JOIN RegularWorkGroups RWG ON RWG.GroupNo = RWJ.GroupNo
		INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
		INNER JOIN RegularWorkJournalDivisions D ON D.DivisionNo = RWJ.DivisionNo
		INNER JOIN Organization_Users U ON U.UserNo = RWJ.RegUserNo
		INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWJ.RegUserNo and B.IsDefault = TRUE
		INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		WHERE RWG.Enabled = TRUE AND RWJ.RegUserNo = work_getjournalsfordaily.userno
			AND (RWJ.CreationDate BETWEEN StartDate AND StartDate)
	) W
	ORDER BY W.ModDate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
