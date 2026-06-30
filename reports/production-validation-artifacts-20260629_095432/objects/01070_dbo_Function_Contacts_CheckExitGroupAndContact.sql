-- ─── FUNCTION: contacts_checkexitgroupandcontact ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_checkexitgroupandcontact(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_checkexitgroupandcontact(
    userno integer,
    contactid integer,
    groupid integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT COUNT(*) FROM ContactsGroupUser
	WHERE RegUserNo=contacts_checkexitgroupandcontact.userno AND UserSeq=contacts_checkexitgroupandcontact.contactid AND GroupNo=contacts_checkexitgroupandcontact.groupid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
