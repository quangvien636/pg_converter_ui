-- ─── FUNCTION: contacts_restorecontactlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_restorecontactlist(integer);
CREATE OR REPLACE FUNCTION public.contacts_restorecontactlist(
    reguserno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ContactsUser SET UseYn='Y', ModDate=NOW() WHERE Seq IN (SELECT * FROM Contacts_StringToListInt(ContactList)) AND RegUserNo=contacts_restorecontactlist.reguserno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
