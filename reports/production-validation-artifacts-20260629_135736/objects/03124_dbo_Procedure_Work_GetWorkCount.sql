-- ─── PROCEDURE→FUNCTION: work_getworkcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getworkcount(integer, integer);
CREATE OR REPLACE FUNCTION public.work_getworkcount(
    IN userno integer,
    IN groupno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT COUNT(*)
	FROM Works W
	INNER JOIN WorkHistorys H ON H.HistoryNo = W.HistoryNo
	WHERE W.GroupNo = work_getworkcount.groupno AND Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
