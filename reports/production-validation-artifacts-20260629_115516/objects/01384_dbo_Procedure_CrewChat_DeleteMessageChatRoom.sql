-- ─── PROCEDURE→FUNCTION: crewchat_deletemessagechatroom ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_deletemessagechatroom(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_deletemessagechatroom(
    IN roomno bigint
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_Messages WHERE RoomNo = crewchat_deletemessagechatroom.roomno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
