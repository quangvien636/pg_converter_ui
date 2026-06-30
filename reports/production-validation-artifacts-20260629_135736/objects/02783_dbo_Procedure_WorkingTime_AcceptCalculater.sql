-- ─── PROCEDURE→FUNCTION: workingtime_acceptcalculater ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_acceptcalculater(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_acceptcalculater(
    IN p_wkday integer,
    IN p_regno integer,
    IN p_type integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_Calculater
	SET Status = workingtime_acceptcalculater.p_type
	WHERE WorkingDay=workingtime_acceptcalculater.p_wkday and UserNo = workingtime_acceptcalculater.p_regno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
