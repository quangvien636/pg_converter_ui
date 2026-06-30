-- ─── PROCEDURE→FUNCTION: workingtime_addbox ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_addbox();
CREATE OR REPLACE FUNCTION public.workingtime_addbox(
) RETURNS void
AS $function$
BEGIN


INSERT INTO WorkingTime_BoxUses(Name) VALUES(p_Name);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
