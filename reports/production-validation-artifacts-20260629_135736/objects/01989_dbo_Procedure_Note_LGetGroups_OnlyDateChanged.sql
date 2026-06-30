-- ─── PROCEDURE→FUNCTION: note_lgetgroups_onlydatechanged ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_lgetgroups_onlydatechanged(integer);
CREATE OR REPLACE FUNCTION public.note_lgetgroups_onlydatechanged(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT GroupNo, DateChanged
	FROM Note_LGroups
	WHERE UserNo = note_lgetgroups_onlydatechanged.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
