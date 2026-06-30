-- ─── FUNCTION: crewchat_deletefavoritechatroom ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_deletefavoritechatroom(integer, bigint);
CREATE OR REPLACE FUNCTION public.crewchat_deletefavoritechatroom(
    userno integer,
    roomno bigint
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_FavoriteChatRoom
	WHERE RegUserNo = crewchat_deletefavoritechatroom.userno AND RoomNo = crewchat_deletefavoritechatroom.roomno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
