-- ─── FUNCTION: notice_mobile_deletecommentnotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_mobile_deletecommentnotice(integer);
CREATE OR REPLACE FUNCTION public.notice_mobile_deletecommentnotice(
    commentno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM NoticeComments WHERE CommentNo = notice_mobile_deletecommentnotice.commentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
