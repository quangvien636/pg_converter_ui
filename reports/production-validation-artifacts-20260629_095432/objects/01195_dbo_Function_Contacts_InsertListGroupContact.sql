-- ─── FUNCTION: contacts_insertlistgroupcontact ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_insertlistgroupcontact(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_insertlistgroupcontact(
    listgroupcontact_contactid integer,
    listgroup_id integer
) RETURNS void
AS $function$
BEGIN

	INSERT INTO Contacts_ListGroupContact(ListGroupContact_ContactId,ListGroup_Id)
	VALUES (ListGroupContact_ContactId,ListGroup_Id);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
