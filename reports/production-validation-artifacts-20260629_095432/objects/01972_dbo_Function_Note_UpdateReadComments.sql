-- ─── FUNCTION: note_updatereadcomments ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_updatereadcomments(uuid);
CREATE OR REPLACE FUNCTION public.note_updatereadcomments(
    commentno uuid
) RETURNS void
AS $function$
BEGIN

	UPDATE Note_Comments
		SET ReadUserList = ReadUserList
		WHERE CommentNo = note_updatereadcomments.commentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
