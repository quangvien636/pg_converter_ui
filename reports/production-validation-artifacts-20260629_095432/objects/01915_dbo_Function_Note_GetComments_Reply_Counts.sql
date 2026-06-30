-- ─── FUNCTION: note_getcomments_reply_counts ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getcomments_reply_counts(uuid);
CREATE OR REPLACE FUNCTION public.note_getcomments_reply_counts(
    parentid uuid
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	IF CAST(ParentID as varchar(64)) != '00000000-0000-0000-0000-000000000000'
	BEGIN
		SELECT Counts = COUNT(CommentNo)
		FROM public."Note_Comments" 
		WHERE ParentID = note_getcomments_reply_counts.parentid

	END

	RETURN QUERY
	SELECT Counts AS Counts;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
