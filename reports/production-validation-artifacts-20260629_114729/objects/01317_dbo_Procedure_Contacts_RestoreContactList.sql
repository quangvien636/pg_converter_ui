-- ─── PROCEDURE→FUNCTION: contacts_restorecontactlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_restorecontactlist(integer);
CREATE OR REPLACE FUNCTION public.contacts_restorecontactlist(
    IN reguserno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ContactsUser SET UseYn='Y', ModDate=NOW() WHERE Seq IN (SELECT * FROM Contacts_StringToListInt(ContactList)) AND RegUserNo=contacts_restorecontactlist.reguserno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
