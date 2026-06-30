-- ─── PROCEDURE→FUNCTION: center_deletepcsession ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_deletepcsession();
CREATE OR REPLACE FUNCTION public.center_deletepcsession(
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_PCSessions WHERE SessionID = SessionID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
