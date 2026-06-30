-- ─── PROCEDURE→FUNCTION: note_getsinglegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_getsinglegroup(uuid, integer);
CREATE OR REPLACE FUNCTION public.note_getsinglegroup(
    IN groupno uuid,
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT * FROM Note_Group
	WHERE GroupNo=note_getsinglegroup.groupno AND UserNo=note_getsinglegroup.userno AND Show=1

	RETURN QUERY
	SELECT * FROM Note_List
	WHERE GroupNo=note_getsinglegroup.groupno AND UserNo=note_getsinglegroup.userno AND Show=1	
	ORDER BY DayCreate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
