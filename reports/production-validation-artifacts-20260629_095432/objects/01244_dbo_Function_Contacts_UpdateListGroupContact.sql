-- ─── FUNCTION: contacts_updatelistgroupcontact ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_updatelistgroupcontact(integer);
CREATE OR REPLACE FUNCTION public.contacts_updatelistgroupcontact(
    contactid integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ContactsUser
	SET GroupList=GroupList
	WHERE Seq=contacts_updatelistgroupcontact.contactid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
