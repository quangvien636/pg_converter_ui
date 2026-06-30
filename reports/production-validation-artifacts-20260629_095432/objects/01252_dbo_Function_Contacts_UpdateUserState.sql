-- ─── FUNCTION: contacts_updateuserstate ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_updateuserstate();
CREATE OR REPLACE FUNCTION public.contacts_updateuserstate(
) RETURNS void
AS $function$
BEGIN

	UPDATE ContactsUser SET UseYn=State
	WHERE Seq = UserSeq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
