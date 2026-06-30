-- ─── FUNCTION: note_getcomments_listno_counts ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getcomments_listno_counts(uuid);
CREATE OR REPLACE FUNCTION public.note_getcomments_listno_counts(
    listno uuid
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	IF CAST(ListNo as varchar(64)) != '00000000-0000-0000-0000-000000000000'
	BEGIN
		SELECT Counts = COUNT(CommentNo)
		FROM public."Note_Comments" 
		WHERE ListNo = note_getcomments_listno_counts.listno  AND  public."Note_Comments".ParentID = '00000000-0000-0000-0000-000000000000'

	END

	RETURN QUERY
	SELECT Counts AS Counts;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
