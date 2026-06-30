-- ─── PROCEDURE→FUNCTION: center_deletequickfunctions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_deletequickfunctions(integer);
CREATE OR REPLACE FUNCTION public.center_deletequickfunctions(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_QuickFunctions WHERE UserNo = center_deletequickfunctions.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
