-- ─── FUNCTION: crewchat_getchatmessagebeforeall ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getchatmessagebeforeall(bigint, integer);
CREATE OR REPLACE FUNCTION public.crewchat_getchatmessagebeforeall(
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
    unreadcount text
)
AS $function$
DECLARE
    msgtable table;
    roomstartmsgno bigint;
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
	

	SELECT RoomStartMsgNo=StartMessageNo FROM CrewChat_RoomUsers 
	WHERE UserNo=crewchat_getchatmessagebeforeall.userno AND RoomNo=crewchat_getchatmessagebeforeall.roomno
	
	INSERT INTO MsgTable
		RETURN QUERY
		SELECT * FROM (
			SELECT M.MessageNo, M.RoomNo, M.UserNo, M.Message, M.Type, M.AttachNo, M.RegDate,
			(SELECT COUNT(*) FROM CrewChat_CheckMessage C 
			WHERE C.RoomNo=M.RoomNo AND C.IsRead = FALSE AND C.MessageNo = M.MessageNo) AS UnReadCount
			FROM CrewChat_Messages M
			WHERE M.RoomNo = crewchat_getchatmessagebeforeall.roomno
			AND M.MessageNo < BaseMsgNo
			AND M.MessageNo >= RoomStartMsgNo
			--ORDER BY M.RegDate DESC
		) T
		ORDER BY T.RegDate ASC
		
	RETURN QUERY
	SELECT MessageNo,RoomNo,UserNo,Message,Type,AttachNo,RegDate,UnReadCount
	FROM MsgTable ORDER BY RegDate ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
