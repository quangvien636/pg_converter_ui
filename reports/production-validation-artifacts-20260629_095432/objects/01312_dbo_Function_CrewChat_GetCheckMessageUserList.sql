-- ─── FUNCTION: crewchat_getcheckmessageuserlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getcheckmessageuserlist(bigint, bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getcheckmessageuserlist(
    roomno bigint,
    messageno bigint
) RETURNS TABLE(
    checkno text,
    messageno text,
    roomno text,
    userno text,
    isread text,
    moddate text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT CheckNo, 
	MessageNo, 
	RoomNo, 
	UserNo, 
	IsRead, 
	ModDate 
	FROM CrewChat_CheckMessage 
	WHERE MessageNo = crewchat_getcheckmessageuserlist.messageno
	AND RoomNo = crewchat_getcheckmessageuserlist.roomno
	ORDER BY CheckNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
