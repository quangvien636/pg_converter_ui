-- ─── FUNCTION: wchat_getchatroommsginfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.wchat_getchatroommsginfo(integer);
CREATE OR REPLACE FUNCTION public.wchat_getchatroommsginfo(
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
	UserNo, IsAttach, AttachNo, RegDate FROM WCHATContents WHERE ContentNo = wchat_getchatroommsginfo.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
