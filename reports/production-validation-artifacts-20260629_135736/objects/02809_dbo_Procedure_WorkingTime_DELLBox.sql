-- ─── PROCEDURE→FUNCTION: workingtime_dellbox ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_dellbox(integer);
CREATE OR REPLACE FUNCTION public.workingtime_dellbox(
    IN p_no integer
) RETURNS void
AS $function$
BEGIN


DELETE FROM WorkingTime_BoxUses WHERE NO = workingtime_dellbox.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
