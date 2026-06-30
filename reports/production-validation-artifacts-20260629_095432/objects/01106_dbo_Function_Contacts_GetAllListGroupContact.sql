-- ─── FUNCTION: contacts_getalllistgroupcontact ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getalllistgroupcontact(integer);
CREATE OR REPLACE FUNCTION public.contacts_getalllistgroupcontact(
    listgroup_id integer
) RETURNS TABLE(
    listgroupcontact_id serial,
    listgroupcontact_contactid integer,
    listgroup_id integer
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM Contacts_ListGroupContact
	WHERE ListGroup_Id=contacts_getalllistgroupcontact.listgroup_id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
