-- ─── FUNCTION: workingtime_save_requestcorrectiontime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_save_requestcorrectiontime(integer, integer, datetimeoffset(7), integer, datetimeoffset(7), integer);
CREATE OR REPLACE FUNCTION public.workingtime_save_requestcorrectiontime(
    workingno integer,
    reguserno integer,
    regdate datetimeoffset(7),
    accuserno integer,
    accdate datetimeoffset(7),
    status integer DEFAULT 0
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	SELECT CountWorkingNo = COUNT(WorkingNo) FROM WorkingTime_RequestCorrectionTime WHERE WorkingNo=workingtime_save_requestcorrectiontime.workingno
	IF CountWorkingNo = 0 BEGIN;
		INSERT INTO WorkingTime_RequestCorrectionTime (WorkingNo,RegUserNo,RegDate,AccUserNo,AccDate,Status)
			VALUES (WorkingNo,RegUserNo,RegDate,RegUserNo,RegDate,0)
	END ELSE BEGIN;
		UPDATE WorkingTime_RequestCorrectionTime
			SET AccUserNo = workingtime_save_requestcorrectiontime.accuserno
				,AccDate = workingtime_save_requestcorrectiontime.accdate
				,Status = workingtime_save_requestcorrectiontime.status
			WHERE WorkingNo = workingtime_save_requestcorrectiontime.workingno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
