-- ─── PROCEDURE→FUNCTION: workingtime_acceptoutcalculater ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_acceptoutcalculater(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_acceptoutcalculater(
    IN p_wkday integer,
    IN p_regno integer,
    IN p_type integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_Calculater
	StatusOut := workingtime_acceptoutcalculater.p_type;
	WHERE WorkingDay=workingtime_acceptoutcalculater.p_wkday and UserNo = workingtime_acceptoutcalculater.p_regno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
