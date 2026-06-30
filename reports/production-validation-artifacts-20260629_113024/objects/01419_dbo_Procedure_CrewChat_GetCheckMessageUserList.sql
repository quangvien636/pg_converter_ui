-- ─── PROCEDURE→FUNCTION: crewchat_getcheckmessageuserlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_getcheckmessageuserlist(bigint, bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getcheckmessageuserlist(
    IN roomno bigint,
    IN messageno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT CheckNo, 
	MessageNo, 
	RoomNo, 
	UserNo, 
	IsRead, 
	ModDate 
	FROM CrewChat_CheckMessage 
	WHERE MessageNo = crewchat_getcheckmessageuserlist.messageno
	AND RoomNo = crewchat_getcheckmessageuserlist.roomno
	ORDER BY CheckNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
