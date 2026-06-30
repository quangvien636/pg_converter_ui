-- ─── FUNCTION: contacts_deletecontact ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_deletecontact(integer);
CREATE OR REPLACE FUNCTION public.contacts_deletecontact(
    contactid integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM ContactsUser WHERE Seq=contacts_deletecontact.contactid;
	DELETE FROM ContactsNumber WHERE UserSeq=contacts_deletecontact.contactid;
	DELETE FROM ContactsEmail WHERE UserSeq=contacts_deletecontact.contactid;
	DELETE FROM ContactsCompany WHERE UserSeq=contacts_deletecontact.contactid;
	DELETE FROM ContactsAddress WHERE UserSeq=contacts_deletecontact.contactid;
	DELETE FROM ContactsHomepage WHERE UserSeq=contacts_deletecontact.contactid;
	DELETE FROM ContactsSns WHERE UserSeq=contacts_deletecontact.contactid;
	DELETE FROM ContactsGroupUser WHERE UserSeq=contacts_deletecontact.contactid;
	DELETE FROM Contacts_ListGroupContact WHERE ListGroupContact_ContactId=contacts_deletecontact.contactid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
