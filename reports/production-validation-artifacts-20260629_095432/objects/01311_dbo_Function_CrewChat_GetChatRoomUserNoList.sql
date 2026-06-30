-- ─── FUNCTION: crewchat_getchatroomusernolist ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getchatroomusernolist(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getchatroomusernolist(
    roomno bigint
) RETURNS TABLE(
    userno text
)
AS $function$
BEGIN

	-- 해당 채팅방의 유저 리스트
	RETURN QUERY
	SELECT UserNo FROM CrewChat_RoomUsers 
	WHERE RoomNo = crewchat_getchatroomusernolist.roomno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
