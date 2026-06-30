-- ─── FUNCTION: noticesyn_mobile_updatecommentnotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_mobile_updatecommentnotice(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.noticesyn_mobile_updatecommentnotice(
    commentno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE NoticeSyn_Comments SET
		ModUserNo = noticesyn_mobile_updatecommentnotice.moduserno,
		ModDate = noticesyn_mobile_updatecommentnotice.moddate,
		Content = Content
	WHERE CommentNo = noticesyn_mobile_updatecommentnotice.commentno

END;
--------------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
