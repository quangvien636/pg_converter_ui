-- ─── FUNCTION: crewchat_getchatroomstartendmessageno ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getchatroomstartendmessageno(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getchatroomstartendmessageno(
    roomno bigint
) RETURNS TABLE(
    startmessageno text,
    endmessageno text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT 
	MIN(MessageNo) as StartMessageNo, 
	MAX(MessageNo) as EndMessageNo
	FROM CrewChat_Messages
	WHERE RoomNo = crewchat_getchatroomstartendmessageno.roomno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
