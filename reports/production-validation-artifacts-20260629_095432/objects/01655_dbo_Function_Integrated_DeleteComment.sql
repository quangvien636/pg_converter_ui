-- ─── FUNCTION: integrated_deletecomment ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_deletecomment(integer);
CREATE OR REPLACE FUNCTION public.integrated_deletecomment(
    commentno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM Integrated_Comments WHERE CommentNo = integrated_deletecomment.commentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
