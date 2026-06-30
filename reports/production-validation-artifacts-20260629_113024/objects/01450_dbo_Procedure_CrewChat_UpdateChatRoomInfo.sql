-- ─── PROCEDURE→FUNCTION: crewchat_updatechatroominfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_updatechatroominfo(bigint, integer);
CREATE OR REPLACE FUNCTION public.crewchat_updatechatroominfo(
    IN roomno bigint,
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE CrewChat_RoomUsers
	RoomTitle := RoomTitle;
	WHERE RoomNo = crewchat_updatechatroominfo.roomno AND UserNo = crewchat_updatechatroominfo.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
