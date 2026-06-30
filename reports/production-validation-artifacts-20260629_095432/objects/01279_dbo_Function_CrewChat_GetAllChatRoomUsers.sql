-- ─── FUNCTION: crewchat_getallchatroomusers ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getallchatroomusers();
CREATE OR REPLACE FUNCTION public.crewchat_getallchatroomusers(
) RETURNS TABLE(
    roomno text,
    userno text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT U.RoomNo, U.UserNo 
	FROM CrewChat_RoomUsers U
	INNER JOIN CrewChat_Rooms R ON R.RoomNo = U.RoomNo
	WHERE R.GroupType = 0 AND R.LastedMsgNo > 0
	ORDER BY RoomNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
