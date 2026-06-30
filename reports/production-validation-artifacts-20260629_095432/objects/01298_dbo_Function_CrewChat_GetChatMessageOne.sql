-- ─── FUNCTION: crewchat_getchatmessageone ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getchatmessageone(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getchatmessageone(
    messageno bigint
) RETURNS TABLE(
    messageno text,
    roomno text,
    userno text,
    message text,
    type text,
    attachno text,
    regdate text,
    col8 text
)
AS $function$
BEGIN

		
	RETURN QUERY
	SELECT M.MessageNo, M.RoomNo, M.UserNo, M.Message, M.Type, M.AttachNo, M.RegDate,
	(SELECT COUNT(*) FROM CrewChat_CheckMessage C 
	WHERE C.RoomNo=M.RoomNo AND C.IsRead = FALSE AND C.MessageNo = M.MessageNo) AS UnReadCount
	FROM CrewChat_Messages M
	WHERE M.MessageNo = crewchat_getchatmessageone.messageno
	ORDER BY M.RegDate ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
