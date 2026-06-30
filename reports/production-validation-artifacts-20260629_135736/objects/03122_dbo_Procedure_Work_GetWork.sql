-- ─── PROCEDURE→FUNCTION: work_getwork ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getwork(integer);
CREATE OR REPLACE FUNCTION public.work_getwork(
    IN workno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT W.WorkNo, H.Title, H.Content,
		H.UserNo, U.Name AS UserName, P.Name AS PositionName, W.GroupNo, W.HistoryNo,
		H.DivisionNo, WD.Name AS DivisionName, H.WorkTime, W.CompletionRate,
		W.RegUserNo, W.RegDate, H.RegDate AS ModDate, H.CompleteDate,
		H.IsEveryPerson, W.Enabled
	FROM Works W
	INNER JOIN WorkHistorys H ON H.HistoryNo = W.HistoryNo
	INNER JOIN WorkDivisions WD ON WD.DivisionNo = H.DivisionNo
	INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
	INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	WHERE W.WorkNo = work_getwork.workno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
