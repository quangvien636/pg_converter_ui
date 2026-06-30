-- ─── PROCEDURE→FUNCTION: workingtime_updateautherkey ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_updateautherkey();
CREATE OR REPLACE FUNCTION public.workingtime_updateautherkey(
) RETURNS void
AS $function$
BEGIN


	update WorkingTime_AutherKey set value = p_Key;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
