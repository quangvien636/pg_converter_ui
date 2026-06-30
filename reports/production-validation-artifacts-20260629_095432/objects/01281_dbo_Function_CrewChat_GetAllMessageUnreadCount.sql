-- ─── FUNCTION: crewchat_getallmessageunreadcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getallmessageunreadcount(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getallmessageunreadcount(
    userno integer
) RETURNS TABLE(
    unreadcount text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT COUNT(*) AS UnReadCount FROM CrewChat_CheckMessage C
	INNER JOIN CrewChat_RoomUsers R ON 
	R.UserNo = crewchat_getallmessageunreadcount.userno AND R.Closed = 0 AND R.RoomNo = C.RoomNo
	AND R.StartMessageNo <= C.MessageNo
	WHERE C.UserNo = crewchat_getallmessageunreadcount.userno AND C.IsRead = FALSE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
