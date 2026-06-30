-- ─── FUNCTION: contacts_getlistgroupwithid ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getlistgroupwithid(integer);
CREATE OR REPLACE FUNCTION public.contacts_getlistgroupwithid(
    listid integer
) RETURNS TABLE(
    listgroup_id serial,
    listgroup_content character varying(250),
    listgroup_regdate timestamp without time zone,
    listgroup_moddate timestamp without time zone
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM Contacts_ListGroup WHERE ListGroup_Id = contacts_getlistgroupwithid.listid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
