-- ─── FUNCTION: work_updatecooperationcomments ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updatecooperationcomments(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_updatecooperationcomments(
    commentno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	update Work_CooperationComments
	set ModUserNo = work_updatecooperationcomments.moduserno
	,ModDate = work_updatecooperationcomments.moddate
	,Content =Content
	WHERE CommentNo = work_updatecooperationcomments.commentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
