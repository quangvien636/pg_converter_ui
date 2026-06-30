-- ─── FUNCTION: workingtime_gettimereturnoutside ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_gettimereturnoutside(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_gettimereturnoutside(
    userno integer,
    workingday integer,
    workingno integer
) RETURNS TABLE(
    col1 text,
    timeoffset text,
    lunchstart text,
    lunchend text,
    isaddlunch text,
    bin1 text,
    bout1 text,
    bin2 text,
    bout2 text,
    isb1 text,
    isb2 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT /* TOP 1 */  CheckTime, TimeOffset, LunchStart, LunchEnd, IsAddLunch, BIn1, BOut1, BIn2, BOut2, IsB1, IsB2
	FROM WorkingTime_Times 
	WHERE TimeType = 4  AND RegUserNo = workingtime_gettimereturnoutside.userno AND WorkingDay =  workingtime_gettimereturnoutside.workingday AND WorkingNo > workingtime_gettimereturnoutside.workingno
	and COALESCE(status,0) != 1
	ORDER BY WorkingNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
