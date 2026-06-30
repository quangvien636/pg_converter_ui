-- ─── FUNCTION: note_getsinglelist ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getsinglelist(uuid, integer);
CREATE OR REPLACE FUNCTION public.note_getsinglelist(
    listno uuid,
    userno integer
) RETURNS TABLE(
    commentno text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT *, FALSE As IsRead,  DayCreate As ReadDate FROM Note_List
	WHERE ListNo=note_getsinglelist.listno

	RETURN QUERY
	SELECT * FROM Note_Attachment
	WHERE ListNo=note_getsinglelist.listno
	ORDER BY IsAvatar DESC,DayCreate DESC

	RETURN QUERY
	SELECT * FROM Note_Share ns
	 WHERE ListNo=note_getsinglelist.listno and (( UserShare in (select UserNo from Organization_Users org where org.UserNo=UserShare and org.Enabled = TRUE) and ShareType=2) or ShareType<>2)
	ORDER BY DayCreate DESC
	
	RETURN QUERY
	SELECT * FROM Note_Attachment
	WHERE ListNo in (Select CommentNo From Note_Comments Where ListNo=note_getsinglelist.listno)
	ORDER BY IsAvatar DESC,DayCreate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
