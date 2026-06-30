-- ─── FUNCTION: notice_updatecomment ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_updatecomment(integer);
CREATE OR REPLACE FUNCTION public.notice_updatecomment(
    commentno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE NoticeComments 
	SET Content = Content, ModDate = NOW()
	WHERE CommentNo = notice_updatecomment.commentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
