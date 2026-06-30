-- ─── PROCEDURE→FUNCTION: note_deleteemptycommment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.note_deleteemptycommment(uuid);
CREATE OR REPLACE FUNCTION public.note_deleteemptycommment(
    IN commentno uuid
) RETURNS void
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	-- Check this comment is empty and it has no child/ no reply;
	Delete from Note_Comments where  CommentNo=note_deleteemptycommment.commentno 
		and len(Content)=0  -- empty comment
		and not exists(Select * From Note_Comments r Where r.ParentID = note_deleteemptycommment.commentno) -- has no child/ no reply
		and not exists(Select * From Note_Attachment a Where a.ListNo = note_deleteemptycommment.commentno);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
