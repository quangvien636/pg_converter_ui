-- ─── FUNCTION: crewchat_insertchatmessage ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_insertchatmessage(bigint, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.crewchat_insertchatmessage(
    roomno bigint,
    userno integer,
    message character varying,
    type integer
) RETURNS TABLE(
    name text
)
AS $function$
DECLARE
    messageno bigint;
    isone boolean;
    roomusercount integer;
    isclosed boolean;
BEGIN


	INSERT INTO CrewChat_Messages (RoomNo, UserNo, Message, Type, AttachNo, RegDate)
	VALUES (RoomNo, UserNo, Message, Type, 0, NOW())
	
	SET MessageNo = lastval()
	
	-- 1:1 채팅방 일 때


	SET IsOne = (SELECT IsOne FROM CrewChat_Rooms WHERE RoomNo = crewchat_insertchatmessage.roomno)
	SET RoomUserCount = (SELECT COUNT(*) FROM CrewChat_RoomUsers WHERE RoomNo = crewchat_insertchatmessage.roomno AND Closed = 0)
	IF IsOne = TRUE AND RoomUserCount = 2
	BEGIN
		-- 상대방이 나간 상태 일 때

		SET IsClosed = (SELECT Closed FROM CrewChat_RoomUsers WHERE RoomNo = crewchat_insertchatmessage.roomno
						 AND UserNo != crewchat_insertchatmessage.userno)
						 
		IF IsClosed = TRUE
		BEGIN
			-- 나간 상태를 다시 돌려놓는다.;
			UPDATE CrewChat_RoomUsers SET Closed = 0, StartMessageNo=MessageNo 
			WHERE RoomNo = crewchat_insertchatmessage.roomno AND UserNo != crewchat_insertchatmessage.userno
		END						 
	END
	
	IF IsOne = TRUE AND RoomUserCount > 2
	BEGIN
		-- 1:1방 상태를 돌려 놓는다.;
		UPDATE CrewChat_Rooms SET IsOne = FALSE WHERE RoomNo = crewchat_insertchatmessage.roomno
	END
	
	RETURN QUERY
	SELECT M.MessageNo, M.RoomNo, M.UserNo, M.Message, M.Type, M.AttachNo, M.RegDate,
	(SELECT COUNT(*) FROM CrewChat_CheckMessage C 
	WHERE C.RoomNo=M.RoomNo AND C.IsRead = FALSE AND C.MessageNo = M.MessageNo) AS UnreadCount,
	(SELECT U.Name FROM Organization_Users U WHERE U.UserNo = M.UserNo) AS UserName
	FROM CrewChat_Messages M
	WHERE M.MessageNo = MessageNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
