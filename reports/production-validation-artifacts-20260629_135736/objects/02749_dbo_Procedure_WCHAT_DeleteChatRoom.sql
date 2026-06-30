-- ─── PROCEDURE→FUNCTION: wchat_deletechatroom ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.wchat_deletechatroom();
CREATE OR REPLACE FUNCTION public.wchat_deletechatroom(
) RETURNS void
AS $function$
BEGIN

			
	-- 채팅방 삭제 처리 (IsClose 값 변경);
	UPDATE WCHATRooms SET IsClose = TRUE WHERE ChatNo IN (SELECT VALUE FROM public."UF_TEXT_SPLIT"(ChatNo,';'));
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
