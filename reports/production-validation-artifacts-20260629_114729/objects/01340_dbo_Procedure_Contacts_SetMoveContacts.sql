-- ─── PROCEDURE→FUNCTION: contacts_setmovecontacts ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_setmovecontacts(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_setmovecontacts(
    IN reguserno integer,
    IN groupno integer,
    IN movegroupno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ContactsGroupUser 
		GroupNo := contacts_setmovecontacts.movegroupno;
		WHERE RegUserNo = contacts_setmovecontacts.reguserno AND GroupNo = contacts_setmovecontacts.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
