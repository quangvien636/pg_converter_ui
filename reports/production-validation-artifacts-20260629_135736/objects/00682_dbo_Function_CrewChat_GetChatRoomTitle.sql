-- ─── FUNCTION: crewchat_getchatroomtitle ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getchatroomtitle(bigint, integer);
CREATE OR REPLACE FUNCTION public.crewchat_getchatroomtitle(
    roomno bigint,
    userno integer
) RETURNS character varying
AS $function$
BEGIN

	

RETURN (SELECT RoomTitle FROM CrewChat_RoomUsers WHERE RoomNo=crewchat_getchatroomtitle.roomno AND UserNo=crewchat_getchatroomtitle.userno);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
