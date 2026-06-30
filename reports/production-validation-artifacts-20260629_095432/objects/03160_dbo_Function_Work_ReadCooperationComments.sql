-- ─── FUNCTION: work_readcooperationcomments ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_readcooperationcomments(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_readcooperationcomments(
    commentno integer,
    userno integer,
    readdate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Work_CooperationCommentReference VALUES (CommentNo, UserNo,ReadDate);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
