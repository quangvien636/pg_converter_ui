-- ─── PROCEDURE→FUNCTION: work_getjournal ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getjournal(integer);
CREATE OR REPLACE FUNCTION public.work_getjournal(
    IN journalno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT WJ.JournalNo, WJ.RegUserNo,
		U.Name AS UserName, P.Name AS PositionName,
		WJ.RegDate, WJ.ModUserNo, WJ.ModDate,
		WJ.WorkNo, WJ.CreationDate, WJ.DivisionNo, WJD.Name AS DivisionName,
		WJ.WorkTime, WJ.CompletionRate, WJ.Content
	FROM WorkJournals WJ
	INNER JOIN WorkJournalDivisions WJD ON WJD.DivisionNo = WJ.DivisionNo
	INNER JOIN Organization_Users U ON U.UserNo = WJ.RegUserNo
	INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo and B.IsDefault = TRUE
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	WHERE JournalNo = work_getjournal.journalno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
