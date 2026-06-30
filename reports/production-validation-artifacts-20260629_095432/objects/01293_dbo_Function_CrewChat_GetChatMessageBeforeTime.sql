-- ─── FUNCTION: crewchat_getchatmessagebeforetime ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getchatmessagebeforetime(bigint, integer);
CREATE OR REPLACE FUNCTION public.crewchat_getchatmessagebeforetime(
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
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    msgtable table;
    roomstartmsgno bigint;
-- !! WARNING: output needs manual review — see TODO comments
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
	WHERE UserNo=crewchat_getchatmessagebeforetime.userno AND RoomNo=crewchat_getchatmessagebeforetime.roomno
	
	INSERT INTO MsgTable
		RETURN QUERY
		SELECT * FROM (
			SELECT /* TOP 20 */ M.MessageNo, M.RoomNo, M.UserNo, M.Message, M.Type, M.AttachNo, M.RegDate,
			(SELECT COUNT(*) FROM CrewChat_CheckMessage C 
			WHERE C.RoomNo=M.RoomNo AND C.IsRead = FALSE AND C.MessageNo = M.MessageNo) AS UnReadCount
			FROM CrewChat_Messages M
			WHERE M.RoomNo = crewchat_getchatmessagebeforetime.roomno
			AND M.RegDate < BaseDate
			AND M.MessageNo >= RoomStartMsgNo
			ORDER BY M.RegDate DESC
		) T
		ORDER BY T.RegDate ASC
		
	RETURN QUERY
	SELECT MessageNo,RoomNo,UserNo,Message,Type,AttachNo,RegDate,UnReadCount
	FROM MsgTable ORDER BY RegDate ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
