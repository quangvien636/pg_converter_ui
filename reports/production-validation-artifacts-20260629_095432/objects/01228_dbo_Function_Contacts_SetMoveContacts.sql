-- ─── FUNCTION: contacts_setmovecontacts ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_setmovecontacts(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_setmovecontacts(
    reguserno integer,
    groupno integer,
    movegroupno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ContactsGroupUser 
		SET GroupNo = contacts_setmovecontacts.movegroupno 
		WHERE RegUserNo = contacts_setmovecontacts.reguserno AND GroupNo = contacts_setmovecontacts.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
