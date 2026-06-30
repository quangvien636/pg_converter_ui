-- ─── FUNCTION: crewchat_getmessageunreadcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getmessageunreadcount(bigint, bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getmessageunreadcount(
    roomno bigint,
    startmsgno bigint
) RETURNS TABLE(
    messageno text,
    col2 text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT M.MessageNo, 
	(SELECT COUNT(CheckNo) FROM CrewChat_CheckMessage C 
	WHERE C.RoomNo=M.RoomNo AND C.IsRead = FALSE AND C.MessageNo = M.MessageNo) AS UnReadCount
	FROM CrewChat_Messages M
	WHERE M.RoomNo = crewchat_getmessageunreadcount.roomno AND M.MessageNo >= crewchat_getmessageunreadcount.startmsgno
	ORDER BY M.RegDate ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
