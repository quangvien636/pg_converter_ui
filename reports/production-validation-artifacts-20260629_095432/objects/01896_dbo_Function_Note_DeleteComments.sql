-- ─── FUNCTION: note_deletecomments ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_deletecomments(uuid);
CREATE OR REPLACE FUNCTION public.note_deletecomments(
    id uuid
) RETURNS void
AS $function$
BEGIN

	IF strNameId = 'commentno'
	BEGIN;
		DELETE FROM Note_Comments WHERE CommentNo = note_deletecomments.id;
		DELETE FROM Note_Comments WHERE ParentID = note_deletecomments.id AND CAST(Id as varchar(64)) != '00000000-0000-0000-0000-000000000000';
		DELETE FROM Note_Attachment WHERE ListNo = note_deletecomments.id
	END
	ELSE IF strNameId = 'noteno'
	BEGIN;
		DELETE FROM Note_Comments WHERE ListNo = note_deletecomments.id
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
