-- ─── FUNCTION: crewchat_getchatroomdata ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getchatroomdata(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getchatroomdata(
    userno integer
) RETURNS TABLE(
    roomno text
)
AS $function$
DECLARE
    tbtemp table
	(
	roomno bigint
	);
BEGIN


	insert into tbTemp
	RETURN QUERY
	select R.RoomNo
	from 
	CrewChat_RoomUsers R
	inner join CrewChat_Rooms M ON M.RoomNo=R.RoomNo AND M.LastedMsgDate is not null
	where R.UserNo=crewchat_getchatroomdata.userno AND R.Closed = 0 AND R.StartMessageNo <= M.LastedMsgNo
	Group by R.RoomNo
	
	--select C.* From CrewChat_CheckMessage C
	--inner join tbTemp T ON T.RoomNo = C.RoomNo
	--where C.IsRead = FALSE and C.UserNo = UserNo
	RETURN QUERY
	select C.* From CrewChat_CheckMessage C
	inner join tbTemp T ON T.RoomNo = C.RoomNo
	INNER JOIN CrewChat_RoomUsers R ON R.RoomNo = T.RoomNo AND R.UserNo=crewchat_getchatroomdata.userno
	where C.IsRead = FALSE and C.UserNo = crewchat_getchatroomdata.userno and R.StartMessageNo <= C.MessageNo

	RETURN QUERY
	select R.* from CrewChat_RoomUsers R
	inner join tbTemp T ON T.RoomNo = R.RoomNo

	RETURN QUERY
	select R.RoomNo, R.MakeUserNo, R.ModDate, R.IsOne, R.LastedMsg, 
	R.LastedMsgDate,
	R.LastedMsgNo, R.LastedMsgType, R.LastedMsgAttachNo, R.LastedMsgAttachType,
	R.LastedMsgAttachName,
	(SELECT UserNo FROM CrewChat_Messages WHERE MessageNo=R.LastedMsgNo) AS MsgUserNo,
	R.RoomType, R.GroupType
	from CrewChat_Rooms R
	inner join tbTemp T ON T.RoomNo = R.RoomNo
	order by R.LastedMsgDate desc
	
	RETURN QUERY
	select RoomNo from CrewChat_FavoriteChatRoom
	where RegUserNo = crewchat_getchatroomdata.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
