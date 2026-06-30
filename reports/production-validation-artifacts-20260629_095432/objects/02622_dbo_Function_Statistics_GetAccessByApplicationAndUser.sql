-- ─── FUNCTION: statistics_getaccessbyapplicationanduser ───────────────────────────────
DROP FUNCTION IF EXISTS public.statistics_getaccessbyapplicationanduser(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.statistics_getaccessbyapplicationanduser(
    year integer,
    applicationno integer,
    rankcount integer
) RETURNS TABLE(
    col1 text,
    accesscount text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT TOP (RankCount) UserNo, COUNT(*) AS AccessCount
	FROM Center_AccessLogs
	WHERE ApplicationNo = statistics_getaccessbyapplicationanduser.applicationno AND DATEPART(YEAR, AccessDate) = statistics_getaccessbyapplicationanduser.year
	GROUP BY UserNo
	ORDER BY AccessCount DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
