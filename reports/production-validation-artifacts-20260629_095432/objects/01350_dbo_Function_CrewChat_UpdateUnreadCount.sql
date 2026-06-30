-- ─── FUNCTION: crewchat_updateunreadcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_updateunreadcount(bigint, integer, bigint);
CREATE OR REPLACE FUNCTION public.crewchat_updateunreadcount(
    roomno bigint,
    userno integer,
    startmsgno bigint
) RETURNS void
AS $function$
BEGIN

	
	UPDATE CrewChat_CheckMessage SET IsRead = TRUE, ModDate=NOW()
	WHERE RoomNo = crewchat_updateunreadcount.roomno AND UserNo = crewchat_updateunreadcount.userno AND IsRead != 1
	AND MessageNo <= crewchat_updateunreadcount.startmsgno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
