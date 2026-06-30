-- ─── FUNCTION: contacts_updatecontactimportant ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_updatecontactimportant(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updatecontactimportant(
    seq integer,
    important integer
) RETURNS void
AS $function$
BEGIN

	UPDATE public."ContactsUser"
   SET Important =contacts_updatecontactimportant.important
 WHERE Seq=contacts_updatecontactimportant.seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
