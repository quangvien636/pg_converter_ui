-- ─── FUNCTION: workingtime_get_requestcorrectiontime_detail ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_get_requestcorrectiontime_detail(character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_get_requestcorrectiontime_detail(
    fromdate character varying DEFAULT '20160601',
    todate character varying DEFAULT '20160631'
) RETURNS TABLE(
    userno text,
    workingno text,
    remark text,
    checkdatetimeoffset text,
    workingdayofcompany text,
    regdate text,
    accdate text,
    status text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT t.UserNo,t.WorkingNo,t.Remark,t2.CheckDateTimeOffset,t2.WorkingDayOfCompany,r.RegDate,r.AccDate,r.Status
		FROM WorkingTime_RequestCorrectionTime r
			INNER JOIN WorkingTime_Times t ON r.WorkingNo = t.WorkingNo
			INNER JOIN WorkingTime_Times_v2 t2 ON r.WorkingNo = t2.WorkingNo
		WHERE t2.WorkingDayOfCompany BETWEEN FromDate AND ToDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
