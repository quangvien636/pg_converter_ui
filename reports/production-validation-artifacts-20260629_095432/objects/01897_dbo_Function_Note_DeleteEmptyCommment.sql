-- ─── FUNCTION: note_deleteemptycommment ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_deleteemptycommment(uuid);
CREATE OR REPLACE FUNCTION public.note_deleteemptycommment(
    commentno uuid
) RETURNS void
-- TODO: LEN was not fully converted; use length()
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
