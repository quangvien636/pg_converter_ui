-- ─── PROCEDURE→FUNCTION: workingtime_updateischeckin ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_updateischeckin(integer);
CREATE OR REPLACE FUNCTION public.workingtime_updateischeckin(
    IN p_no integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_Calculater
	IsCheckIn := 1;
	WHERE Calculaterno=workingtime_updateischeckin.p_no
END;


--EXEC WorkingTime_UpdateIsCheckIn 9262
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
