-- ─── FUNCTION: workingtime_get_totalpage_requestcorrectiontime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_get_totalpage_requestcorrectiontime(character varying);
CREATE OR REPLACE FUNCTION public.workingtime_get_totalpage_requestcorrectiontime(
    fromdate character varying
) RETURNS TABLE(
    totalpage text
)
AS $function$
BEGIN

	
		RETURN QUERY
		SELECT  COUNT(*) AS totalPage

			FROM WorkingTime_Times t INNER JOIN WorkingTime_Times_v2 t2 ON t.WorkingNo = t2.WorkingNo
									 INNER JOIN WorkingTime_RequestCorrectionTime r ON t.WorkingNo = r.WorkingNo

			WHERE t2.WorkingDayOfCompany BETWEEN  FromDate AND ToDate
					AND (t.Provider = 999);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
