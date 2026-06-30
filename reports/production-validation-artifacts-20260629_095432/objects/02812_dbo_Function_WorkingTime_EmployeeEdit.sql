-- ─── FUNCTION: workingtime_employeeedit ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_employeeedit(timestamp without time zone, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.workingtime_employeeedit(
    fromdate timestamp without time zone,
    todate timestamp without time zone,
    userno integer
) RETURNS TABLE(
    reguserno text,
    date text,
    timetype text,
    contentdate text,
    timeoffset text
)
AS $function$
BEGIN

	IF(ToDate>NOW())
		Set ToDate = NOW()
	RETURN QUERY
	SELECT t1.RegUserNo
		, CONVERT(varchar(10),t1.checktimefull,120) AS "Date"
		, MIN(t1.TimeType) as TimeType
		, MIN(t1.checktimefull) AS "ContentDate"
		, t1.timeoffset
	FROM public."WorkingTime_Times" t1 
			where t1.Provider=999 
			and t1.RegUserNo = workingtime_employeeedit.userno
			and t1.checktimefull >= workingtime_employeeedit.fromdate 
			and t1.checktimefull<=workingtime_employeeedit.todate

				GROUP BY  t1.reguserno, t1.timeoffset,CONVERT(varchar(10),t1.checktimefull,120)
	ORDER BY CONVERT(varchar(10),t1.checktimefull,120) asc, t1.timeoffset;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
