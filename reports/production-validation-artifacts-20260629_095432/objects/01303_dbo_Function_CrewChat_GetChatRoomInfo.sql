-- ─── FUNCTION: crewchat_getchatroominfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getchatroominfo(bigint, integer);
CREATE OR REPLACE FUNCTION public.crewchat_getchatroominfo(
    roomno bigint,
    userno integer
) RETURNS TABLE(
    roomno text
)
AS $function$
BEGIN

	-- 해당방의 기본 정보와 맴버정보를 보냅니다.
	RETURN QUERY
	SELECT R.RoomNo, R.MakeUserNo, R.ModDate, R.IsOne, U.RoomTitle, 
    R.LastedMsgNo, R.LastedMsg, R.LastedMsgDate, U.UserNo, U.Notification,
    R.LastedMsgType, R.LastedMsgAttachType, R.LastedMsgAttachNo,
    R.LastedMsgAttachName,
    (SELECT UserNo FROM CrewChat_Messages WHERE MessageNo=R.LastedMsgNo) AS MsgUserNo,
    R.RoomType, R.GroupType
	FROM CrewChat_Rooms R 
	INNER JOIN CrewChat_RoomUsers U ON U.RoomNo = R.RoomNo
	WHERE R.RoomNo = crewchat_getchatroominfo.roomno
	
	RETURN QUERY
	SELECT COUNT(*) AS UnReadCount FROM CrewChat_CheckMessage
	WHERE IsRead = FALSE AND UserNo = crewchat_getchatroominfo.userno AND RoomNo=crewchat_getchatroominfo.roomno
	
	RETURN QUERY
	select RoomNo from CrewChat_FavoriteChatRoom
	where RegUserNo = crewchat_getchatroominfo.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
