-- ─── FUNCTION: crewchat_getchatroominfo_my ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getchatroominfo_my(bigint, integer);
CREATE OR REPLACE FUNCTION public.crewchat_getchatroominfo_my(
    roomno bigint,
    userno integer
) RETURNS TABLE(
    roomno text,
    makeuserno text,
    moddate text,
    isone text,
    lastedmsgno text,
    lastedmsg text,
    lastedmsgdate text,
    userno text,
    notification text,
    roomtitle text,
    lastedmsgtype text,
    lastedmsgattachtype text,
    lastedmsgattachno text,
    lastedmsgattachname text,
    col15 text
)
AS $function$
BEGIN

	-- 해당방의 기본 정보와 맴버정보를 보냅니다.
	RETURN QUERY
	SELECT R.RoomNo, R.MakeUserNo, R.ModDate, R.IsOne, 
    R.LastedMsgNo, R.LastedMsg, R.LastedMsgDate, U.UserNo, U.Notification, U.RoomTitle,
    R.LastedMsgType, R.LastedMsgAttachType, R.LastedMsgAttachNo,
    R.LastedMsgAttachName,
    (SELECT UserNo FROM CrewChat_Messages WHERE MessageNo=R.LastedMsgNo) AS MsgUserNo,
    R.RoomType, R.GroupType
	FROM CrewChat_Rooms R 
	INNER JOIN CrewChat_RoomUsers U ON U.RoomNo = R.RoomNo AND U.UserNo = crewchat_getchatroominfo_my.userno
	WHERE R.RoomNo = crewchat_getchatroominfo_my.roomno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
