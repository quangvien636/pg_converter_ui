-- ─── FUNCTION: wchat_getchatroomnewmsg ───────────────────────────────
DROP FUNCTION IF EXISTS public.wchat_getchatroomnewmsg(integer, integer);
CREATE OR REPLACE FUNCTION public.wchat_getchatroomnewmsg(
    chatno integer,
    contentno integer
) RETURNS TABLE(
    contentno text,
    chatno text,
    content text,
    userno text,
    isattach text,
    attachno text,
    regdate text
)
AS $function$
BEGIN


	
	RETURN QUERY
	SELECT ContentNo, ChatNo, Content, 
	UserNo, IsAttach, AttachNo, RegDate FROM WCHATContents WHERE ChatNo = wchat_getchatroomnewmsg.chatno
	AND ContentNo > wchat_getchatroomnewmsg.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
