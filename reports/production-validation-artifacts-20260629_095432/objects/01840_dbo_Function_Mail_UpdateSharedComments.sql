-- ─── FUNCTION: mail_updatesharedcomments ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatesharedcomments(integer, integer);
CREATE OR REPLACE FUNCTION public.mail_updatesharedcomments(
    commentno integer,
    commentstype integer
) RETURNS void
AS $function$
BEGIN


	update Mail_SharedComments
	set 
	ModDate = NOW()
	,CommentsType = mail_updatesharedcomments.commentstype
	,Content =Content
	WHERE CommentNo = mail_updatesharedcomments.commentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
