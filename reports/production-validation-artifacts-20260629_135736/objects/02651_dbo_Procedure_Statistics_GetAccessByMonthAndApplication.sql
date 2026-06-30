-- ─── PROCEDURE→FUNCTION: statistics_getaccessbymonthandapplication ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.statistics_getaccessbymonthandapplication(integer, integer);
CREATE OR REPLACE FUNCTION public.statistics_getaccessbymonthandapplication(
    IN year integer,
    IN month integer
) RETURNS SETOF record
AS $function$
DECLARE
    yearmonth character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	IF Month < 10 THEN
	
		YearMonth := CONVERT(VARCHAR, Year) + '0' || CONVERT(VARCHAR, Month);
	END IF;
	
	ELSE BEGIN
	
		YearMonth := CONVERT(VARCHAR, Year) + CONVERT(VARCHAR, Month);
	END;
	
	RETURN QUERY
	SELECT ApplicationNo, COUNT(*) AS AccessCount
	FROM Center_AccessLogs
	WHERE SUBSTRING(CONVERT(VARCHAR, AccessDate, 112), 1, 6) = YearMonth
	GROUP BY ApplicationNo, SUBSTRING(CONVERT(VARCHAR, AccessDate, 112), 1, 6);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
