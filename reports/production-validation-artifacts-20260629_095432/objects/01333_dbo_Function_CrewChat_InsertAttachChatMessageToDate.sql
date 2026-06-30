-- ─── FUNCTION: crewchat_insertattachchatmessagetodate ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_insertattachchatmessagetodate(bigint, integer, character varying, integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.crewchat_insertattachchatmessagetodate(
    roomno bigint,
    userno integer,
    message character varying,
    attachno integer,
    type integer,
    regdate timestamp without time zone
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    messageno bigint;
    isone boolean;
    isclosed boolean;
BEGIN


	INSERT INTO CrewChat_Messages (RoomNo, UserNo, Message, Type, AttachNo, RegDate)
	VALUES (RoomNo, UserNo, Message, Type, AttachNo, RegDate)
	
	SET MessageNo = lastval()
	
	-- 1:1 채팅방 일 때

	SET IsOne = (SELECT IsOne FROM CrewChat_Rooms WHERE RoomNo = crewchat_insertattachchatmessagetodate.roomno)
	IF IsOne = TRUE
	BEGIN
		-- 상대방이 나간 상태 일 때

		SET IsClosed = (SELECT Closed FROM CrewChat_RoomUsers WHERE RoomNo = crewchat_insertattachchatmessagetodate.roomno
						 AND UserNo != crewchat_insertattachchatmessagetodate.userno)
						 
		IF IsClosed = TRUE
		BEGIN
			-- 나간 상태를 다시 돌려놓는다.;
			UPDATE CrewChat_RoomUsers SET Closed = 0, StartMessageNo=MessageNo 
			WHERE RoomNo = crewchat_insertattachchatmessagetodate.roomno AND UserNo != crewchat_insertattachchatmessagetodate.userno
		END						 
	END
	
	RETURN QUERY
	SELECT M.MessageNo, M.RoomNo, M.UserNo, 
	(SELECT U.Name FROM Organization_Users U WHERE U.UserNo = M.UserNo) AS UserName, 
	M.Message, M.Type, M.AttachNo, M.RegDate,
	(SELECT COUNT(CheckNo) FROM CrewChat_CheckMessage C 
	WHERE C.RoomNo=M.RoomNo AND C.IsRead = FALSE AND C.MessageNo = M.MessageNo) AS UnreadCount
	FROM CrewChat_Messages M
	WHERE M.MessageNo = MessageNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
