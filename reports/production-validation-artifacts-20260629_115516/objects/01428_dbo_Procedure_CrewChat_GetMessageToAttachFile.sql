-- ─── PROCEDURE→FUNCTION: crewchat_getmessagetoattachfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_getmessagetoattachfile(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getmessagetoattachfile(
    IN attachno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	RETURN QUERY
	SELECT MessageNo, Type, RegDate
	FROM CrewChat_Messages
	WHERE AttachNo = crewchat_getmessagetoattachfile.attachno
	ORDER BY RegDate ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
