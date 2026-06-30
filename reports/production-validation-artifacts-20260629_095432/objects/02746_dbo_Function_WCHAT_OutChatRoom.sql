-- ─── FUNCTION: wchat_outchatroom ───────────────────────────────
DROP FUNCTION IF EXISTS public.wchat_outchatroom(integer, integer);
CREATE OR REPLACE FUNCTION public.wchat_outchatroom(
    chatno integer,
    userno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    usercnt integer;
BEGIN


	
	-- 해당방의 맴버에서 삭제;
	DELETE FROM WCHATMembers 
	WHERE ChatNo = wchat_outchatroom.chatno AND UserNo = wchat_outchatroom.userno
	
	-- 해당방에 사람이 존재하는지 체크

	SELECT UserCnt=COUNT(*) FROM WCHATMembers WHERE ChatNo = wchat_outchatroom.chatno
	
	-- 사람이 없다면 방을 삭제한다.(방/방의 메시지)
	IF UserCnt = 0
	BEGIN
		-- 채팅방 삭제;
		DELETE FROM WCHATRooms WHERE ChatNo = wchat_outchatroom.chatno
		-- 채팅방의 메시지들을 삭제;
		DELETE FROM WCHATContents WHERE ChatNo = wchat_outchatroom.chatno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
