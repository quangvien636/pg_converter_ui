-- ─── PROCEDURE→FUNCTION: work_getworkgroupcountpergroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getworkgroupcountpergroup(integer);
CREATE OR REPLACE FUNCTION public.work_getworkgroupcountpergroup(
    IN searchtype integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF SearchType = 0 THEN

		RETURN QUERY
		SELECT COUNT(*)
		FROM WorkGroups WG
		WHERE WG.Enabled = TRUE
	
	END IF;
	
	ELSIF SearchType = 1 THEN
	
		RETURN QUERY
		SELECT COUNT(*)
		FROM WorkGroups WG
		INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
			AND WGH.Name ILIKE '%' || SearchText || '%'
		WHERE WG.Enabled = TRUE
	
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
