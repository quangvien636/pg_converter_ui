-- ─── PROCEDURE→FUNCTION: work_getjournalsforlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getjournalsforlist(integer, date, date, integer, integer);
CREATE OR REPLACE FUNCTION public.work_getjournalsforlist(
    IN userno integer,
    IN startdate date,
    IN enddate date,
    IN viewcount integer,
    IN currentpageindex integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT * FROM (
		SELECT ROW_NUMBER() OVER (ORDER BY WJ.RegDate DESC) AS RowNum,
			WJ.JournalNo, WJ.WorkNo, WGH.Name AS GroupName,
			WD.Name AS DivisionName, WH.Title, U.Name AS UserName, P.Name AS PositionName,
			WJ.WorkTime, WJ.CompletionRate
		FROM WorkJournals WJ
		INNER JOIN Works W ON W.WorkNo = WJ.WorkNo
		INNER JOIN WorkHistorys WH ON WH.HistoryNo = W.HistoryNo
		INNER JOIN WorkDivisions WD ON WD.DivisionNo = WH.DivisionNo
		INNER JOIN WorkGroups WG ON WG.GroupNo = W.GroupNo
		INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
		INNER JOIN Organization_Users U ON U.UserNo = WGH.UserNo
		INNER JOIN Organization_BelongToDepartment B ON B.UserNo = WGH.UserNo and B.IsDefault = TRUE
		INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		WHERE WJ.RegUserNo = work_getjournalsforlist.userno AND CONVERT(DATE, WJ.CreationDate) = work_getjournalsforlist.startdate
	) AS T
	WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
