-- ─── FUNCTION: noticesyn_deletecomment ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_deletecomment(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_deletecomment(
    commentno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM NoticeSyn_Comments WHERE CommentNo = noticesyn_deletecomment.commentno
END;
-------------------------///////////////////////////---------------
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
