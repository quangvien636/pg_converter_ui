-- ─── PROCEDURE→FUNCTION: workingtime_updateother ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_updateother(integer);
CREATE OR REPLACE FUNCTION public.workingtime_updateother(
    IN p_wkno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_Times 
	NameCompany := p_name;
	WHERE WorkingNo = workingtime_updateother.p_wkno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
