-- ─── FUNCTION: mail_insertsharedcomments ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertsharedcomments(bigint, integer, integer);
CREATE OR REPLACE FUNCTION public.mail_insertsharedcomments(
    mailno bigint,
    reguserno integer,
    commentstype integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Mail_SharedComments(MailNo,RegUserNo,RegDate,ModDate,CommentsType,Content) 
	VALUES (MailNo,RegUserNo, NOW(), NOW(),CommentsType,Content);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
