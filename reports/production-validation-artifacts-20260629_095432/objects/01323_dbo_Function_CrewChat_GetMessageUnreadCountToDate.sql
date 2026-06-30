-- ─── FUNCTION: crewchat_getmessageunreadcounttodate ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getmessageunreadcounttodate(bigint, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.crewchat_getmessageunreadcounttodate(
    roomno bigint,
    basedate timestamp without time zone
) RETURNS TABLE(
    messageno text,
    col2 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT * FROM (
	SELECT /* TOP 20 */ M.MessageNo, 
	(SELECT COUNT(CheckNo) FROM CrewChat_CheckMessage C WITH (UPDLOCK)
	WHERE C.RoomNo=M.RoomNo AND C.IsRead = FALSE AND C.MessageNo = M.MessageNo) AS UnReadCount,
	M.RegDate
	FROM CrewChat_Messages M WITH (UPDLOCK)
	--WHERE M.RoomNo = RoomNo AND M.RegDate >= BaseDate
	WHERE M.RoomNo = crewchat_getmessageunreadcounttodate.roomno AND M.RegDate <= crewchat_getmessageunreadcounttodate.basedate
	ORDER BY M.RegDate DESC) T ORDER BY RegDate ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
