-- ─── PROCEDURE→FUNCTION: note_getnotelistcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_getnotelistcount(character varying, boolean);
CREATE OR REPLACE FUNCTION public.note_getnotelistcount(
    IN boxtype character varying,
    IN isread boolean DEFAULT TRUE
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT 
		COUNT(NoteNo) AS CNT
	FROM NoteList N
	INNER JOIN NoteBox B ON N.UserNo = B.UserNo AND N.NoteBoxNo = B.NoteBoxNo
	WHERE N.UserNo = UserNo
	AND B.BoxType = note_getnotelistcount.boxtype
	AND (N.IsRead = note_getnotelistcount.isread OR 1=note_getnotelistcount.isread);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
