-- ─── FUNCTION: noticesyn_mobile_deletecommentnotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_mobile_deletecommentnotice(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_mobile_deletecommentnotice(
    commentno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM NoticeSyn_Comments WHERE CommentNo = noticesyn_mobile_deletecommentnotice.commentno

END;
------------------------ -----------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
