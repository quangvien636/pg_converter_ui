-- ─── FUNCTION: crewchat_getchatmessagefirst ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getchatmessagefirst(bigint, integer);
CREATE OR REPLACE FUNCTION public.crewchat_getchatmessagefirst(
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

	-- 마지막 메시지 No, 해당 유저 방 초대시 메시지 No


	SELECT RoomStartMsgNo=StartMessageNo FROM CrewChat_RoomUsers 
	WHERE RoomNo=crewchat_getchatmessagefirst.roomno AND UserNo=crewchat_getchatmessagefirst.userno
	
	SET LastedMsgNo = (SELECT /* TOP 1 */ MessageNo FROM CrewChat_Messages
		WHERE RoomNo = crewchat_getchatmessagefirst.roomno ORDER BY MessageNo DESC)

		INSERT INTO MsgTable
		RETURN QUERY
		SELECT * FROM (
			SELECT /* TOP 20 */ M.MessageNo, M.RoomNo, M.UserNo, M.Message, M.Type, M.AttachNo, M.RegDate,
			(SELECT COUNT(*) FROM CrewChat_CheckMessage C 
			WHERE C.RoomNo=M.RoomNo AND C.IsRead = FALSE AND C.MessageNo = M.MessageNo) AS UnReadCount
			FROM CrewChat_Messages M
			WHERE M.RoomNo = crewchat_getchatmessagefirst.roomno AND M.MessageNo <= LastedMsgNo
			AND M.MessageNo >= RoomStartMsgNo
			ORDER BY M.RegDate DESC
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
