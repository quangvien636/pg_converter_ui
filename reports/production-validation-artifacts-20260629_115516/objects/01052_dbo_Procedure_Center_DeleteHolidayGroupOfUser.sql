-- ─── PROCEDURE→FUNCTION: center_deleteholidaygroupofuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_deleteholidaygroupofuser(integer);
CREATE OR REPLACE FUNCTION public.center_deleteholidaygroupofuser(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_HolidayGroupOfUsers WHERE UserNo = center_deleteholidaygroupofuser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
