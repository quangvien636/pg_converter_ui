-- ─── FUNCTION: mail_updatemailtag ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemailtag(bigint, integer);
CREATE OR REPLACE FUNCTION public.mail_updatemailtag(
    tagno bigint,
    imageno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_MailTags SET ImageNo = mail_updatemailtag.imageno, Name = Name
	WHERE TagNo = mail_updatemailtag.tagno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
