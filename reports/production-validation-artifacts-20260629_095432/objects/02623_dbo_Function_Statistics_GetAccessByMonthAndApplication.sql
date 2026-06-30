-- ─── FUNCTION: statistics_getaccessbymonthandapplication ───────────────────────────────
DROP FUNCTION IF EXISTS public.statistics_getaccessbymonthandapplication(integer, integer);
CREATE OR REPLACE FUNCTION public.statistics_getaccessbymonthandapplication(
    year integer,
    month integer
) RETURNS TABLE(
    applicationno text,
    accesscount text
)
AS $function$
DECLARE
    yearmonth character varying;
BEGIN



	IF Month < 10 BEGIN
	
		SET YearMonth = CONVERT(VARCHAR, Year) + '0' || CONVERT(VARCHAR, Month)
	
	END
	
	ELSE BEGIN
	
		SET YearMonth = CONVERT(VARCHAR, Year) + CONVERT(VARCHAR, Month)
	
	END
	
	RETURN QUERY
	SELECT ApplicationNo, COUNT(*) AS AccessCount
	FROM Center_AccessLogs
	WHERE SUBSTRING(CONVERT(VARCHAR, AccessDate, 112), 1, 6) = YearMonth
	GROUP BY ApplicationNo, SUBSTRING(CONVERT(VARCHAR, AccessDate, 112), 1, 6);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
