-- ─── PROCEDURE→FUNCTION: workingtime_workingtimebox ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_workingtimebox(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_workingtimebox(
    IN p_wo integer,
    IN p_bno integer
) RETURNS void
AS $function$
BEGIN

UPDATE WorkingTime_Times
		bno := workingtime_workingtimebox.p_wo,;
			bname=p_bname
		WHERE WorkingNo = workingtime_workingtimebox.p_wo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
