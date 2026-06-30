-- ─── FUNCTION: noticesyn_updatecomment ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_updatecomment(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_updatecomment(
    commentno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE NoticeSyn_Comments 
	SET Content = Content, ModDate = NOW()
	WHERE CommentNo = noticesyn_updatecomment.commentno
	
END;
----------------------------------/////////////
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
