-- ─── FUNCTION: contacts_listgroupcontent ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_listgroupcontent(integer);
CREATE OR REPLACE FUNCTION public.contacts_listgroupcontent(
    contact_id integer
) RETURNS TABLE(
    listgroup_content text
)
AS $function$
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
