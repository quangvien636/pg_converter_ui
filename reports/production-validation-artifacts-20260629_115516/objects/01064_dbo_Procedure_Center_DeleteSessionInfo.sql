-- ─── PROCEDURE→FUNCTION: center_deletesessioninfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_deletesessioninfo(integer);
CREATE OR REPLACE FUNCTION public.center_deletesessioninfo(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_Sessions WHERE UserNo = center_deletesessioninfo.userno AND SessionID = SessionID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
