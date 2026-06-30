-- ─── PROCEDURE→FUNCTION: workingtime_insert_requestcorrectiontime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_insert_requestcorrectiontime(integer, integer, double precision);
CREATE OR REPLACE FUNCTION public.workingtime_insert_requestcorrectiontime(
    IN workingno integer,
    IN reguserno integer,
    IN timeoffset double precision
) RETURNS void
AS $function$
DECLARE
    regdate timestamp with time zone;
BEGIN



	RegDate := switchoffset(CONVERT(datetimeoffset, SYSDATETIMEOFFSET()), public."ChangeTimeOffset"(TimeOffset));;
	INSERT INTO WorkingTime_RequestCorrectionTime (WorkingNo,RegUserNo,RegDate,AccUserNo,AccDate,Status)
		VALUES (WorkingNo,RegUserNo,RegDate,RegUserNo,RegDate,0);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
