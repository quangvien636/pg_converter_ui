-- ─── PROCEDURE→FUNCTION: note_lgetallofnotes_onlydatechanged ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_lgetallofnotes_onlydatechanged(integer);
CREATE OR REPLACE FUNCTION public.note_lgetallofnotes_onlydatechanged(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT NoteNo, DateChanged
	FROM Note_LNotes
	WHERE UserNo = note_lgetallofnotes_onlydatechanged.userno OR NoteNo IN (SELECT NoteNo FROM Note_LSharers WHERE UserShare = note_lgetallofnotes_onlydatechanged.userno);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
