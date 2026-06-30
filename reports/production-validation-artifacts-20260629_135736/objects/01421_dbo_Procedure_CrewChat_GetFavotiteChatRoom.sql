-- ─── PROCEDURE→FUNCTION: crewchat_getfavotitechatroom ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_getfavotitechatroom(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getfavotitechatroom(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT FavoriteChatRoomNo, RegUserNo, RoomNo, ModDate FROM CrewChat_FavoriteChatRoom
	WHERE RegUserNo = crewchat_getfavotitechatroom.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
