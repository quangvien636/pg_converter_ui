-- ─── PROCEDURE→FUNCTION: note_lgetcomments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_lgetcomments(uuid);
CREATE OR REPLACE FUNCTION public.note_lgetcomments(
    IN noteno uuid
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT C.CommentNo, C.ListNo, C.RegUserNo, C.RegDate, C.ModUserNo, C.ModDate, C.Content, C.ParentID,
		U.Name, U.Name_EN, U.UserPhoto, U.Photo
	FROM Note_Comments C
	LEFT JOIN Organization_Users U ON U.UserNo = C.RegUserNo
	WHERE ListNo = note_lgetcomments.noteno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
