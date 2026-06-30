-- ─── PROCEDURE→FUNCTION: vacation_savesetups ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_savesetups(boolean);
CREATE OR REPLACE FUNCTION public.vacation_savesetups(
    IN p_vl boolean
) RETURNS void
AS $function$
BEGIN

	update Vacation_Setups
	val := vacation_savesetups.p_vl;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
