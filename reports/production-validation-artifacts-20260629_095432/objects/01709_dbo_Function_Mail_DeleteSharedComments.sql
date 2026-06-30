-- ─── FUNCTION: mail_deletesharedcomments ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_deletesharedcomments(integer);
CREATE OR REPLACE FUNCTION public.mail_deletesharedcomments(
    commentno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Mail_SharedComments WHERE CommentNo = mail_deletesharedcomments.commentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
