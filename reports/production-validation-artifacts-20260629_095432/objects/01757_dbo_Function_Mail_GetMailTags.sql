-- ─── FUNCTION: mail_getmailtags ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailtags(integer);
CREATE OR REPLACE FUNCTION public.mail_getmailtags(
    userno integer
) RETURNS TABLE(
    tagno text,
    imageno text,
    name text,
    totalcount text,
    unreadcount text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT TagNo, ImageNo, Name, TotalCount, UnReadCount
	FROM Mail_MailTags
	WHERE UserNo = mail_getmailtags.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
