-- ─── PROCEDURE→FUNCTION: contacts_getalllistgroupcontact ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getalllistgroupcontact(integer);
CREATE OR REPLACE FUNCTION public.contacts_getalllistgroupcontact(
    IN listgroup_id integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT * FROM Contacts_ListGroupContact
	WHERE ListGroup_Id=contacts_getalllistgroupcontact.listgroup_id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
