-- ─── FUNCTION: crewchat_getfavotitechatroom ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getfavotitechatroom(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getfavotitechatroom(
    userno integer
) RETURNS TABLE(
    favoritechatroomno text,
    reguserno text,
    roomno text,
    moddate text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT FavoriteChatRoomNo, RegUserNo, RoomNo, ModDate FROM CrewChat_FavoriteChatRoom
	WHERE RegUserNo = crewchat_getfavotitechatroom.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
