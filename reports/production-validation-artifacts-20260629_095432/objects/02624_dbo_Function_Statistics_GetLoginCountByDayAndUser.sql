-- ─── FUNCTION: statistics_getlogincountbydayanduser ───────────────────────────────
DROP FUNCTION IF EXISTS public.statistics_getlogincountbydayanduser(date, integer);
CREATE OR REPLACE FUNCTION public.statistics_getlogincountbydayanduser(
    date date,
    rankcount integer
) RETURNS TABLE(
    col1 text,
    logincount text
)
AS $function$
DECLARE
    _date character varying;
BEGIN



	SET _Date = CONVERT(VARCHAR, Date, 112)

	RETURN QUERY
	SELECT TOP (RankCount) UserNo, COUNT(*) AS LoginCount
	FROM Center_LoginLogs
	WHERE CONVERT(VARCHAR, LoginDate, 112) = _Date
	GROUP BY UserNo
	ORDER BY LoginCount DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
