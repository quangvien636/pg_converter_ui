-- ─── PROCEDURE→FUNCTION: work_getalljournalspergroupanduser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getalljournalspergroupanduser(integer, integer, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_getalljournalspergroupanduser(
    IN groupno integer,
    IN userno integer,
    IN startdate timestamp without time zone,
    IN enddate timestamp without time zone
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT WJ.JournalNo, WJ.CreationDate,
		WH.Title, WD.Name AS DivisionName, WJ.Content,
		WJ.WorkTime, WJ.CompletionRate, WJ.ModDate
	FROM WorkJournals WJ
	INNER JOIN Works W ON W.WorkNo = WJ.WorkNo
	INNER JOIN WorkHistorys WH ON WH.HistoryNo = W.HistoryNo
	INNER JOIN WorkDivisions WD ON WD.DivisionNo = WH.DivisionNo
	INNER JOIN WorkGroups WG ON WG.GroupNo = W.GroupNo AND WG.GroupNo = work_getalljournalspergroupanduser.groupno
	INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
	INNER JOIN Organization_Users U ON U.UserNo = WJ.RegUserNo AND U.UserNo = work_getalljournalspergroupanduser.userno
	INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo and B.IsDefault = TRUE
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	WHERE WG.Enabled = TRUE AND (WJ.CreationDate BETWEEN StartDate AND EndDate)
	ORDER BY WJ.CreationDate ASC, ModDate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
