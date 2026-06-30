-- ─── FUNCTION: crewchat_getchatallmessages ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getchatallmessages(bigint, integer);
CREATE OR REPLACE FUNCTION public.crewchat_getchatallmessages(
    roomno bigint,
    userno integer
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
DECLARE
    startmsgno bigint;
BEGIN

	-- 해당 유저의 시작 메시지 번호를 가져옵니다.

	SET StartMsgNo = (SELECT StartMessageNo FROM CrewChat_RoomUsers
	WHERE RoomNo = crewchat_getchatallmessages.roomno AND UserNo = crewchat_getchatallmessages.userno)
	
	RETURN QUERY
	SELECT M.MessageNo, M.RoomNo, M.UserNo, M.Message, M.Type, M.AttachNo, M.RegDate,
	(SELECT COUNT(*) FROM CrewChat_CheckMessage C 
	WHERE C.RoomNo=M.RoomNo AND C.IsRead = FALSE AND C.MessageNo = M.MessageNo) AS UnReadCount
	FROM CrewChat_Messages M
	WHERE M.RoomNo = crewchat_getchatallmessages.roomno AND M.MessageNo >= StartMsgNo AND type = 0
	ORDER BY M.RegDate ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
