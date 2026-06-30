-- ─── FUNCTION: crewchat_getchatroomandusers ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getchatroomandusers(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getchatroomandusers(
    roomno bigint
) RETURNS TABLE(
    roomno text,
    makeuserno text,
    moddate text,
    isone text,
    roomtitle text,
    userno text
)
AS $function$
BEGIN

	-- 해당방의 기본 정보와 맴버정보를 보냅니다.
	RETURN QUERY
	SELECT R.RoomNo, R.MakeUserNo, R.ModDate, R.IsOne, U.RoomTitle, U.UserNo
	FROM CrewChat_Rooms R 
	INNER JOIN CrewChat_RoomUsers U ON U.RoomNo = R.RoomNo
	WHERE R.RoomNo = crewchat_getchatroomandusers.roomno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
