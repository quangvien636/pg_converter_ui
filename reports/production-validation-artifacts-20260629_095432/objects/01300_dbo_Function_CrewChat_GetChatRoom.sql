-- ─── FUNCTION: crewchat_getchatroom ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getchatroom(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getchatroom(
    roomno bigint
) RETURNS TABLE(
    roomno text,
    makeuserno text,
    moddate text,
    isone text,
    roomtype text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT RoomNo, MakeUserNo, ModDate, IsOne, RoomType FROM CrewChat_Rooms
	WHERE RoomNo = crewchat_getchatroom.roomno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
