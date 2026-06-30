-- ─── PROCEDURE→FUNCTION: note_getsinglenotesmaps ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_getsinglenotesmaps(uuid);
CREATE OR REPLACE FUNCTION public.note_getsinglenotesmaps(
    IN listno uuid
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT * FROM Note_Share
	WHERE ListNo=note_getsinglenotesmaps.listno
	ORDER BY DayCreate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
