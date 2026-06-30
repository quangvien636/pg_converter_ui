-- ─── PROCEDURE→FUNCTION: contacts_insertlistgroupcontact ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_insertlistgroupcontact(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_insertlistgroupcontact(
    IN listgroupcontact_contactid integer,
    IN listgroup_id integer
) RETURNS void
AS $function$
BEGIN

	INSERT INTO Contacts_ListGroupContact(ListGroupContact_ContactId,ListGroup_Id)
	VALUES (ListGroupContact_ContactId,ListGroup_Id);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
