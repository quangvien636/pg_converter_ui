-- ─── FUNCTION: vacation_vacationgetdays ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_vacationgetdays(integer);
CREATE OR REPLACE FUNCTION public.vacation_vacationgetdays(
    p_uno integer
) RETURNS TABLE(
    col1 text,
    userno text
)
AS $function$
BEGIN



				RETURN QUERY
				SELECT 
					 COALESCE(V.Vacations,0)  + COALESCE(X2.TimeDis,0) - COALESCE(v.Used,0) - COALESCE(X3.Used,0)  AS Vacations
				FROM  Vacation_Vacations V 
				LEFT JOIN (
					select SUM(TimeDis) TimeDis from Vacation_RequestEps ep 
					where ep.UsernoI = vacation_vacationgetdays.p_uno AND YEAR(ep.Tod) = p_y 
				) X2 ON 1 =  1
				LEFT JOIN (
					 select SUM(VacationsCount) Used, RQ.UserNo
					 from Vacation_Requests RQ 
					 left join Vacation_Types t on rq.TypeId = t.TypeId
					 WHERE RQ.StatusAdmin != 1 and RQ.UserNo = vacation_vacationgetdays.p_uno AND YEAR(rq.Tod) = p_y 
					 GROUP BY RQ.UserNo
				) X3 ON V.UserNo =  X3.UserNo
				WHERE v.UserNo = vacation_vacationgetdays.p_uno and years = p_y;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
