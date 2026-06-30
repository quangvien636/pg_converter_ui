-- ─── FUNCTION: dday_insertcoveredday ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_insertcoveredday(integer, bigint, date);
CREATE OR REPLACE FUNCTION public.dday_insertcoveredday(
    userno integer,
    dayno bigint,
    covereddate date
) RETURNS TABLE(
    datano text
)
AS $function$
DECLARE
    datano bigint;
BEGIN


	INSERT INTO DDay_CoveredDays (UserNo, DayNo, CoveredDate)
	VALUES (UserNo, DayNo, CoveredDate)


	SET DataNo = lastval()
	
	RETURN QUERY
	SELECT DataNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
