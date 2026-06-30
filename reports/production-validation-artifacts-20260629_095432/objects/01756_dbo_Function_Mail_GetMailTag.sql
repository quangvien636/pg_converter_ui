-- ─── FUNCTION: mail_getmailtag ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailtag(bigint);
CREATE OR REPLACE FUNCTION public.mail_getmailtag(
    tagno bigint
) RETURNS TABLE(
    tagno text,
    userno text,
    imageno text,
    name text,
    totalcount text,
    unreadcount text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT TagNo, UserNo, ImageNo, Name, TotalCount, UnReadCount
	FROM Mail_MailTags
	WHERE TagNo = mail_getmailtag.tagno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
