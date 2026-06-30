-- ─── FUNCTION: crewchat_getchatroomunreadcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getchatroomunreadcount(bigint, integer);
CREATE OR REPLACE FUNCTION public.crewchat_getchatroomunreadcount(
    roomno bigint,
    userno integer
) RETURNS bigint
AS $function$
BEGIN



	SELECT CNT=COUNT(*) FROM CrewChat_CheckMessage
	WHERE RoomNo = crewchat_getchatroomunreadcount.roomno AND UserNo = crewchat_getchatroomunreadcount.userno AND IsRead = FALSE

RETURN CNT;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
