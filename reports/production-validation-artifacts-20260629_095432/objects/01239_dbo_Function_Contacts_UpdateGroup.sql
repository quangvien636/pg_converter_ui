-- ─── FUNCTION: contacts_updategroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_updategroup(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updategroup(
    reguserno integer,
    groupno integer
) RETURNS void
AS $function$
BEGIN
	UPDATE ContactsGroup SET GroupName=GroupName 
	WHERE GroupNo=contacts_updategroup.groupno AND RegUserNo = contacts_updategroup.reguserno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
