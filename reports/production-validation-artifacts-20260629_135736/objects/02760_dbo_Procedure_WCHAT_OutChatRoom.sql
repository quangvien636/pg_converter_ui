-- ─── PROCEDURE→FUNCTION: wchat_outchatroom ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.wchat_outchatroom(integer, integer);
CREATE OR REPLACE FUNCTION public.wchat_outchatroom(
    IN chatno integer,
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    usercnt integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	-- 해당방의 맴버에서 삭제;
	DELETE FROM WCHATMembers 
	WHERE ChatNo = wchat_outchatroom.chatno AND UserNo = wchat_outchatroom.userno
	
	-- 해당방에 사람이 존재하는지 체크

	SELECT COUNT(*) INTO usercnt FROM WCHATMembers WHERE ChatNo = wchat_outchatroom.chatno
	
	-- 사람이 없다면 방을 삭제한다.(방/방의 메시지)
	IF UserCnt = 0 THEN
		-- 채팅방 삭제;
		DELETE FROM WCHATRooms WHERE ChatNo = wchat_outchatroom.chatno
		-- 채팅방의 메시지들을 삭제;
		DELETE FROM WCHATContents WHERE ChatNo = wchat_outchatroom.chatno
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
