-- ─── FUNCTION: crewchat_updatechatroominfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_updatechatroominfo(bigint, integer);
CREATE OR REPLACE FUNCTION public.crewchat_updatechatroominfo(
    roomno bigint,
    userno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE CrewChat_RoomUsers
	SET RoomTitle = RoomTitle
	WHERE RoomNo = crewchat_updatechatroominfo.roomno AND UserNo = crewchat_updatechatroominfo.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
