-- ─── FUNCTION: crewchat_deletemessagechatroom ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_deletemessagechatroom(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_deletemessagechatroom(
    roomno bigint
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_Messages WHERE RoomNo = crewchat_deletemessagechatroom.roomno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
