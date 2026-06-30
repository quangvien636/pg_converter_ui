-- ─── PROCEDURE→FUNCTION: note_updatereadcomments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_updatereadcomments(uuid);
CREATE OR REPLACE FUNCTION public.note_updatereadcomments(
    IN commentno uuid
) RETURNS void
AS $function$
BEGIN

	UPDATE Note_Comments
		ReadUserList := ReadUserList;
		WHERE CommentNo = note_updatereadcomments.commentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
