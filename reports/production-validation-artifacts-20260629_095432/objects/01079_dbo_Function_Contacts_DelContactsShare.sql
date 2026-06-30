-- ─── FUNCTION: contacts_delcontactsshare ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_delcontactsshare(integer);
CREATE OR REPLACE FUNCTION public.contacts_delcontactsshare(
    seq integer
) RETURNS void
AS $function$
BEGIN

	delete from ContactsSharers where Seq=contacts_delcontactsshare.seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
