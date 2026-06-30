-- ─── FUNCTION: contacts_setcallphone ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_setcallphone(integer);
CREATE OR REPLACE FUNCTION public.contacts_setcallphone(
    seq integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ContactsNumber
	SET SetCall=1
	WHERE Seq=contacts_setcallphone.seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
