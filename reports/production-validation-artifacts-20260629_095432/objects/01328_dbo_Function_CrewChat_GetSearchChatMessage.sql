-- ─── FUNCTION: crewchat_getsearchchatmessage ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getsearchchatmessage(bigint, integer, character varying, bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getsearchchatmessage(
    roomno bigint,
    userno integer,
    searchtext character varying,
    msgno bigint
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
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    startmsgno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SET StartMsgNo = (SELECT StartMessageNo FROM CrewChat_RoomUsers
	WHERE RoomNo = crewchat_getsearchchatmessage.roomno AND UserNo = crewchat_getsearchchatmessage.userno)
	
	IF MsgNo = 0
	BEGIN
		RETURN QUERY
		SELECT /* TOP 20 */ M.MessageNo, M.RoomNo, M.UserNo, M.Message, 
		M.Type, M.AttachNo, M.RegDate,
		(SELECT COUNT(*) FROM CrewChat_CheckMessage C 
		WHERE C.RoomNo=M.RoomNo AND C.IsRead = FALSE AND C.MessageNo = M.MessageNo) AS UnReadCount
		FROM CrewChat_Messages M
		WHERE M.RoomNo = crewchat_getsearchchatmessage.roomno AND M.MessageNo >= StartMsgNo 
		AND (Type=0 OR Type=3) AND MessageNo > crewchat_getsearchchatmessage.msgno
		AND Message ILIKE '%' || SearchText || '%' 
		ORDER BY M.MessageNo DESC
	END
	ELSE
	BEGIN
		RETURN QUERY
		SELECT /* TOP 20 */ M.MessageNo, M.RoomNo, M.UserNo, M.Message, 
		M.Type, M.AttachNo, M.RegDate,
		(SELECT COUNT(*) FROM CrewChat_CheckMessage C 
		WHERE C.RoomNo=M.RoomNo AND C.IsRead = FALSE AND C.MessageNo = M.MessageNo) AS UnReadCount
		FROM CrewChat_Messages M
		WHERE M.RoomNo = crewchat_getsearchchatmessage.roomno AND M.MessageNo >= StartMsgNo 
		AND (Type=0 OR Type=3) AND MessageNo < crewchat_getsearchchatmessage.msgno
		AND Message ILIKE '%' || SearchText || '%' 
		ORDER BY M.MessageNo DESC
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
