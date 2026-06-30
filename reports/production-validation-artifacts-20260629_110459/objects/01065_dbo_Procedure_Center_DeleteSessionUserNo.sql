-- ─── PROCEDURE→FUNCTION: center_deletesessionuserno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_deletesessionuserno(integer);
CREATE OR REPLACE FUNCTION public.center_deletesessionuserno(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_Sessions WHERE UserNo = center_deletesessionuserno.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
