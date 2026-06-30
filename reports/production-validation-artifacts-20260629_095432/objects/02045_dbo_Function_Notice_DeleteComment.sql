-- ─── FUNCTION: notice_deletecomment ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_deletecomment(integer);
CREATE OR REPLACE FUNCTION public.notice_deletecomment(
    commentno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM NoticeComments WHERE CommentNo = notice_deletecomment.commentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
