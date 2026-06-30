-- ─── PROCEDURE→FUNCTION: note_lgetgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_lgetgroup(uuid);
CREATE OR REPLACE FUNCTION public.note_lgetgroup(
    IN groupno uuid
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT GroupNo, UserNo, Name, DateCreated,DateChanged, IsDefault
	FROM Note_LGroups
	WHERE GroupNo = note_lgetgroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
