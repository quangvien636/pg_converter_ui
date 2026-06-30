-- ─── FUNCTION: wchat_insertchatroommsg ───────────────────────────────
DROP FUNCTION IF EXISTS public.wchat_insertchatroommsg(integer, integer);
CREATE OR REPLACE FUNCTION public.wchat_insertchatroommsg(
    chatno integer,
    userno integer
) RETURNS TABLE(
    msgno text
)
AS $function$
DECLARE
    msgno integer;
BEGIN


	
	INSERT INTO WCHATContents (ChatNo, UserNo, Content) VALUES
	(ChatNo, UserNo, Msg)
	

	SET MsgNo = lastval()
	
	RETURN QUERY
	SELECT MsgNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
