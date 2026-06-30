-- ─── PROCEDURE→FUNCTION: contacts_listgroupcontent ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_listgroupcontent(integer);
CREATE OR REPLACE FUNCTION public.contacts_listgroupcontent(
    IN contact_id integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT ListGroup_Content
	FROM Contacts_ListGroupContact CL
	INNER JOIN contacts_ListGroup LG
	ON CL.ListGroup_Id=LG.ListGroup_Id
	WHERE CL.ListGroupContact_ContactId=contacts_listgroupcontent.contact_id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
