-- ─── FUNCTION: dday_getcovereddays ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_getcovereddays(integer);
CREATE OR REPLACE FUNCTION public.dday_getcovereddays(
    userno integer
) RETURNS TABLE(
    datano text,
    dayno text,
    covereddate text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT DataNo, DayNo, CoveredDate FROM DDay_CoveredDays
	WHERE UserNo = dday_getcovereddays.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
