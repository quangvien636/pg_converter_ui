-- ─── FUNCTION: crewchat_getchatmessagenew ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getchatmessagenew(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getchatmessagenew(
    roomno bigint
) RETURNS TABLE(
    messageno text,
    roomno text,
    userno text,
    message text,
    type text,
    attachno text,
    regdate text,
    unreadcount text
)
AS $function$
DECLARE
    msgtable table;
BEGIN


	(
		MessageNo BIGINT,
		RoomNo BIGINT,
		UserNo INT,
		Message text,
		Type INT,
		AttachNo INT,
		RegDate DateTime,
		UnReadCount INT
	)
	
	INSERT INTO MsgTable
		RETURN QUERY
		SELECT * FROM (
			SELECT M.MessageNo, M.RoomNo, M.UserNo, M.Message, M.Type, M.AttachNo, M.RegDate,
			(SELECT COUNT(*) FROM CrewChat_CheckMessage C 
			WHERE C.RoomNo=M.RoomNo AND C.IsRead = FALSE AND C.MessageNo = M.MessageNo) AS UnReadCount
			FROM CrewChat_Messages M
			WHERE M.RoomNo = crewchat_getchatmessagenew.roomno
			AND M.MessageNo > BaseMsgNo

		) T
		ORDER BY T.RegDate ASC
		
		-- 최종 결과
	RETURN QUERY
	SELECT MessageNo,RoomNo,UserNo,Message,Type,AttachNo,RegDate,UnReadCount
	FROM MsgTable ORDER BY RegDate ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
