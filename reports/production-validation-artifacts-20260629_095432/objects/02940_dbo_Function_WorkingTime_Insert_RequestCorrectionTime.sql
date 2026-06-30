-- ─── FUNCTION: workingtime_insert_requestcorrectiontime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_insert_requestcorrectiontime(integer, integer, double precision);
CREATE OR REPLACE FUNCTION public.workingtime_insert_requestcorrectiontime(
    workingno integer,
    reguserno integer,
    timeoffset double precision
) RETURNS void
AS $function$
DECLARE
    regdate datetimeoffset;
BEGIN



	SET RegDate = switchoffset(CONVERT(datetimeoffset, SYSDATETIMEOFFSET()), public."ChangeTimeOffset"(TimeOffset)); 

	INSERT INTO WorkingTime_RequestCorrectionTime (WorkingNo,RegUserNo,RegDate,AccUserNo,AccDate,Status)
		VALUES (WorkingNo,RegUserNo,RegDate,RegUserNo,RegDate,0);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
