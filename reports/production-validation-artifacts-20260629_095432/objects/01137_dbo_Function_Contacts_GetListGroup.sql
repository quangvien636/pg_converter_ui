-- ─── FUNCTION: contacts_getlistgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getlistgroup(integer);
CREATE OR REPLACE FUNCTION public.contacts_getlistgroup(
    contactid integer
) RETURNS TABLE(
    listgroupcontact_id serial,
    listgroupcontact_contactid integer,
    listgroup_id integer
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM Contacts_ListGroupContact
	WHERE ListGroupContact_ContactId=contacts_getlistgroup.contactid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
