-- ─── FUNCTION: crewchat_getchatroomlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getchatroomlist(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getchatroomlist(
    userno integer
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- 채팅방 리스트에 보여줄 채팅방 기본정보 조회
	-- 최신 메시지 순, 최신방 순으로 조회
	RETURN QUERY
	SELECT R.RoomNo, R.MakeUserNo, R.ModDate, R.IsOne, U.RoomTitle,

	COALESCE((SELECT /* TOP 1 */ Message FROM CrewChat_Messages MS 
	WHERE MS.RoomNo = R.RoomNo AND MS.MessageNo >= U.StartMessageNo
	ORDER BY MS.RegDate DESC),'') AS LastedMsg,
	
	COALESCE((SELECT /* TOP 1 */ RegDate FROM CrewChat_Messages MS 
	WHERE MS.RoomNo = R.RoomNo AND MS.MessageNo >= U.StartMessageNo
	ORDER BY MS.RegDate DESC),'') AS LastedMsgDate,
	
	COALESCE((SELECT /* TOP 1 */ Type FROM CrewChat_Messages MS 
	WHERE MS.RoomNo = R.RoomNo AND MS.MessageNo >= U.StartMessageNo
	ORDER BY MS.RegDate DESC),'') AS LastedMsgType,
	
	COALESCE((SELECT Type FROM CrewChat_Attach WHERE AttachNo = (SELECT /* TOP 1 */ AttachNo FROM CrewChat_Messages MS 
	WHERE MS.RoomNo = R.RoomNo AND MS.MessageNo >= U.StartMessageNo
	ORDER BY MS.RegDate DESC)),'') AS LastedMsgAttachType,
	
	(SELECT COUNT(*) FROM CrewChat_CheckMessage C 
	WHERE C.RoomNo=R.RoomNo AND C.IsRead = FALSE AND C.UserNo=crewchat_getchatroomlist.userno
	AND C.MessageNo >= U.StartMessageNo) AS UnReadCount
	
	FROM CrewChat_Rooms R
	INNER JOIN CrewChat_RoomUsers U ON U.RoomNo = R.RoomNo AND U.UserNo = crewchat_getchatroomlist.userno
	WHERE 
	(SELECT COUNT(*) FROM CrewChat_Messages M WHERE R.RoomNo = M.RoomNo) > 0
	AND (SELECT COUNT(*) FROM CrewChat_RoomUsers RU WHERE R.RoomNo = RU.RoomNo) > 1
	ORDER BY 
	(SELECT COUNT(*) FROM CrewChat_CheckMessage C 
	WHERE C.RoomNo=R.RoomNo AND C.IsRead = FALSE AND C.UserNo=crewchat_getchatroomlist.userno) DESC,
	(SELECT /* TOP 1 */ RegDate FROM CrewChat_Messages MS 
	WHERE MS.RoomNo = R.RoomNo ORDER BY MS.RegDate DESC) DESC, 
	R.ModDate DESC;
	
	--SELECT R.RoomNo, R.MakeUserNo, R.ModDate, R.IsOne, U.RoomTitle,
	--COALESCE((SELECT /* TOP 1 */ Message FROM CrewChat_Messages MS 
	--WHERE MS.RoomNo = R.RoomNo AND (MS.Type=0 OR MS.Type=2) AND MS.MessageNo >= U.StartMessageNo
	--ORDER BY MS.RegDate DESC),'') AS LastedMsg,
	--COALESCE((SELECT /* TOP 1 */ RegDate FROM CrewChat_Messages MS 
	--WHERE MS.RoomNo = R.RoomNo AND (MS.Type=0 OR MS.Type=2) AND MS.MessageNo >= U.StartMessageNo
	--ORDER BY MS.RegDate DESC),'') AS LastedMsgDate,
	--(SELECT COUNT(*) FROM CrewChat_CheckMessage C 
	--WHERE C.RoomNo=R.RoomNo AND C.IsRead = FALSE AND C.UserNo=UserNo
	--AND C.MessageNo >= U.StartMessageNo) AS UnReadCount
	
	--FROM CrewChat_Rooms R
	--INNER JOIN CrewChat_RoomUsers U ON U.RoomNo = R.RoomNo AND U.UserNo = UserNo
	--WHERE 
	--(SELECT COUNT(*) FROM CrewChat_Messages M WHERE R.RoomNo = M.RoomNo 
	--AND (M.Type=0 OR M.Type=2)) > 0
	--AND (SELECT COUNT(*) FROM CrewChat_RoomUsers RU WHERE R.RoomNo = RU.RoomNo) > 1
	--ORDER BY 
	--(SELECT COUNT(*) FROM CrewChat_CheckMessage C 
	--WHERE C.RoomNo=R.RoomNo AND C.IsRead = FALSE AND C.UserNo=UserNo) DESC,
	--(SELECT /* TOP 1 */ RegDate FROM CrewChat_Messages MS 
	--WHERE MS.RoomNo = R.RoomNo ORDER BY MS.RegDate DESC) DESC, 
	--R.ModDate DESC
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
