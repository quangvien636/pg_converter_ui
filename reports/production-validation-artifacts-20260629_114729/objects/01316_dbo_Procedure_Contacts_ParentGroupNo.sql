-- ─── PROCEDURE→FUNCTION: contacts_parentgroupno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_parentgroupno(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_parentgroupno(
    IN reguserno integer,
    IN groupno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	RETURN QUERY
	SELECT ParentGNo FROM ContactsGroup WHERE RegUserNo = contacts_parentgroupno.reguserno and GroupNo = contacts_parentgroupno.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
