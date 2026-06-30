-- ─── FUNCTION: workingtime_update_requestcorrectiontime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_update_requestcorrectiontime(integer, double precision);
CREATE OR REPLACE FUNCTION public.workingtime_update_requestcorrectiontime(
    p_wkno integer,
    p_offset double precision
) RETURNS void
AS $function$
DECLARE
    regdate datetimeoffset;
BEGIN



	SET RegDate = switchoffset(CONVERT(datetimeoffset, SYSDATETIMEOFFSET()), public."ChangeTimeOffset"(p_Offset)); ;
	update WorkingTime_RequestCorrectionTime 
	set Status = 0, Reject = 0, RegDate = RegDate, AccDate = RegDate
	where WorkingNo = workingtime_update_requestcorrectiontime.p_wkno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
