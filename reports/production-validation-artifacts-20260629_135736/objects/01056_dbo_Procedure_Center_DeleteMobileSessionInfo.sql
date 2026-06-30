-- ─── PROCEDURE→FUNCTION: center_deletemobilesessioninfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_deletemobilesessioninfo(integer);
CREATE OR REPLACE FUNCTION public.center_deletemobilesessioninfo(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_MobileSessions WHERE UserNo = center_deletemobilesessioninfo.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
