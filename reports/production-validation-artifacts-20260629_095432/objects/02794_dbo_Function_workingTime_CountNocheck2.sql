-- ─── FUNCTION: workingtime_countnocheck2 ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_countnocheck2(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_countnocheck2(
    p_from integer,
    p_to integer,
    p_uno integer
) RETURNS integer
AS $function$
BEGIN



	set  v_RESULT = ( 
		select COUNT(1)
		FROM WorkingTime_DateInsert V
		WHERE V.DATEINT >= workingtime_countnocheck2.p_from 
		AND V.DATEINT <=  workingtime_countnocheck2.p_to
		AND V.DateInt NOT IN (
			SELECT T.WorkingDayC FROM WorkingTime_Times T  WHERE T.WorkingDayC >= workingtime_countnocheck2.p_from AND T.WorkingDayC <=  workingtime_countnocheck2.p_to 
			AND T.REGUSERNO = workingtime_countnocheck2.p_uno
		)
		AND V.DAYOFWEEK NOT IN
		(
			SELECT CASE WHEN SUN = 0 THEN 0 ELSE -1 END FROM WorkingTime_WeekDays W WHERE W.ID = 1
			UNION ALL
			SELECT CASE WHEN MON = 0 THEN 1 ELSE -1 END FROM WorkingTime_WeekDays W WHERE W.ID = 1
			UNION ALL
			SELECT CASE WHEN TUE = 0 THEN 2 ELSE -1 END FROM WorkingTime_WeekDays W WHERE W.ID = 1
			UNION ALL
			SELECT CASE WHEN WEN = 0 THEN 3 ELSE -1 END FROM WorkingTime_WeekDays W WHERE W.ID = 1
			UNION ALL
			SELECT CASE WHEN THUR = 0 THEN 4 ELSE -1 END FROM WorkingTime_WeekDays W WHERE W.ID = 1
			UNION ALL
			SELECT CASE WHEN FRI = 0 THEN 5 ELSE -1 END FROM WorkingTime_WeekDays W WHERE W.ID = 1
			UNION ALL
			SELECT CASE WHEN SAT = 0 THEN 6 ELSE -1 END FROM WorkingTime_WeekDays W WHERE W.ID = 1
		)
	);
	RETURN v_RESULT;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
