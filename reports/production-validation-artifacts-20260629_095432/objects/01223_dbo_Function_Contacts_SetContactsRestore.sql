-- ─── FUNCTION: contacts_setcontactsrestore ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_setcontactsrestore(integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_setcontactsrestore(
    reguserno integer,
    userno character varying
) RETURNS void
AS $function$
BEGIN

	UPDATE ContactsUser SET UseYn='Y' WHERE Seq=contacts_setcontactsrestore.userno AND RegUserNo=contacts_setcontactsrestore.reguserno;
	UPDATE ContactsGroupUser SET GroupNo=GroupNo WHERE UserSeq=contacts_setcontactsrestore.userno AND RegUserNo=contacts_setcontactsrestore.reguserno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
