-- ─── PROCEDURE→FUNCTION: workingtime_delworkingtime2 ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_delworkingtime2(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_delworkingtime2(
    IN p_wno integer,
    IN p_uno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_Times
	status := 1;
		,DateDelete  = NOW()
		,Userdeleted  = workingtime_delworkingtime2.p_uno
	WHERE WORKINGNO = workingtime_delworkingtime2.p_wno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
