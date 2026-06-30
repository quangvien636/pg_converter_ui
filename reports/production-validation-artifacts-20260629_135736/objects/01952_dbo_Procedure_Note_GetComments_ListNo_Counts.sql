-- ─── PROCEDURE→FUNCTION: note_getcomments_listno_counts ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_getcomments_listno_counts(uuid);
CREATE OR REPLACE FUNCTION public.note_getcomments_listno_counts(
    IN listno uuid
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF CAST(ListNo as varchar(64)) != '00000000-0000-0000-0000-000000000000' THEN
		SELECT  INTO  FROM public."Note_Comments" 
		WHERE ListNo = note_getcomments_listno_counts.listno  AND  public."Note_Comments".ParentID = '00000000-0000-0000-0000-000000000000'

	END IF;

	RETURN QUERY
	SELECT Counts AS Counts;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
