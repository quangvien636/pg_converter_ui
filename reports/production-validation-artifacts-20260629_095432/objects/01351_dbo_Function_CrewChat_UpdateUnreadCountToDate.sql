-- ─── FUNCTION: crewchat_updateunreadcounttodate ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_updateunreadcounttodate(bigint, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.crewchat_updateunreadcounttodate(
    roomno bigint,
    userno integer,
    basedate timestamp without time zone
) RETURNS TABLE(
    count text
)
AS $function$
BEGIN

	
	UPDATE CrewChat_CheckMessage SET IsRead = TRUE, ModDate=NOW()
	WHERE RoomNo = crewchat_updateunreadcounttodate.roomno AND UserNo = crewchat_updateunreadcounttodate.userno AND IsRead != 1
	AND RegDate <= crewchat_updateunreadcounttodate.basedate
	--AND RegDate >= BaseDate
	
	RETURN QUERY
	SELECT @ROWCOUNT AS COUNT;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
