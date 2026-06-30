-- ─── PROCEDURE→FUNCTION: crewchat_getpcsessionuserno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_getpcsessionuserno(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getpcsessionuserno(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT SessionNo, UserNo, SessionID, DeviceNo
	FROM CrewChat_PCSessions
	WHERE UserNo = crewchat_getpcsessionuserno.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
