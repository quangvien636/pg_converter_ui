-- ─── PROCEDURE→FUNCTION: crewchat_getchatroomusernolist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_getchatroomusernolist(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getchatroomusernolist(
    IN roomno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- 해당 채팅방의 유저 리스트
	RETURN QUERY
	SELECT UserNo FROM CrewChat_RoomUsers 
	WHERE RoomNo = crewchat_getchatroomusernolist.roomno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
