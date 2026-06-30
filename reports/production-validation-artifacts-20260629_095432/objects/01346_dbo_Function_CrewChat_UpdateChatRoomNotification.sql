-- ─── FUNCTION: crewchat_updatechatroomnotification ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_updatechatroomnotification(bigint, integer, boolean);
CREATE OR REPLACE FUNCTION public.crewchat_updatechatroomnotification(
    roomno bigint,
    userno integer,
    notification boolean
) RETURNS void
AS $function$
BEGIN

	UPDATE CrewChat_RoomUsers SET Notification = crewchat_updatechatroomnotification.notification
	WHERE RoomNo = crewchat_updatechatroomnotification.roomno AND UserNo = crewchat_updatechatroomnotification.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
