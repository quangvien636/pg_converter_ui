-- ─── PROCEDURE→FUNCTION: note_getsinglelist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_getsinglelist(uuid, integer);
CREATE OR REPLACE FUNCTION public.note_getsinglelist(
    IN listno uuid,
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
