-- ─── PROCEDURE→FUNCTION: workingtime_save_requestcorrectiontime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_save_requestcorrectiontime(integer, integer, timestamp with time zone, integer, timestamp with time zone, integer);
CREATE OR REPLACE FUNCTION public.workingtime_save_requestcorrectiontime(
    IN workingno integer,
    IN reguserno integer,
    IN regdate timestamp with time zone,
    IN accuserno integer,
    IN accdate timestamp with time zone,
    IN status integer DEFAULT 0
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT COUNT(WorkingNo) INTO countworkingno FROM WorkingTime_RequestCorrectionTime WHERE WorkingNo=workingtime_save_requestcorrectiontime.workingno
	IF CountWorkingNo = 0 THEN;
		INSERT INTO WorkingTime_RequestCorrectionTime (WorkingNo,RegUserNo,RegDate,AccUserNo,AccDate,Status)
			VALUES (WorkingNo,RegUserNo,RegDate,RegUserNo,RegDate,0)
	END ELSE BEGIN;
		UPDATE WorkingTime_RequestCorrectionTime
			AccUserNo := workingtime_save_requestcorrectiontime.accuserno;
				,AccDate = workingtime_save_requestcorrectiontime.accdate
				,Status = workingtime_save_requestcorrectiontime.status
			WHERE WorkingNo = workingtime_save_requestcorrectiontime.workingno
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
