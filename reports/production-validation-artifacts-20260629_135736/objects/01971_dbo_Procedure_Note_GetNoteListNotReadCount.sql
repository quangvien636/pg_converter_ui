-- ─── PROCEDURE→FUNCTION: note_getnotelistnotreadcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_getnotelistnotreadcount();
CREATE OR REPLACE FUNCTION public.note_getnotelistnotreadcount(
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
	AND N.IsRead = FALSE
	AND B.BoxType = BoxType;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
