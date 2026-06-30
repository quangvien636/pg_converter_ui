-- ─── PROCEDURE→FUNCTION: center_getmobilesession ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getmobilesession(character varying);
CREATE OR REPLACE FUNCTION public.center_getmobilesession(
    IN sessionid character varying DEFAULT 'AF09159542384847966E440C540FD844'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT SessionNo, UserNo, DeviceNo
	FROM Center_MobileSessions
	WHERE SessionID = center_getmobilesession.sessionid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
