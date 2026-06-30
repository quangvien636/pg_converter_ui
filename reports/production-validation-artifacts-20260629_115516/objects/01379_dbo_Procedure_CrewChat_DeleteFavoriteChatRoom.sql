-- ─── PROCEDURE→FUNCTION: crewchat_deletefavoritechatroom ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_deletefavoritechatroom(integer, bigint);
CREATE OR REPLACE FUNCTION public.crewchat_deletefavoritechatroom(
    IN userno integer,
    IN roomno bigint
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_FavoriteChatRoom
	WHERE RegUserNo = crewchat_deletefavoritechatroom.userno AND RoomNo = crewchat_deletefavoritechatroom.roomno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
