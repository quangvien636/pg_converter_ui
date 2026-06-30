-- ─── FUNCTION: work_delcooperationcomments ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_delcooperationcomments(integer);
CREATE OR REPLACE FUNCTION public.work_delcooperationcomments(
    commentno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Work_CooperationComments
	WHERE CommentNo = work_delcooperationcomments.commentno;
	DELETE FROM Work_CooperationCommentReference
	WHERE CommentNo = work_delcooperationcomments.commentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
