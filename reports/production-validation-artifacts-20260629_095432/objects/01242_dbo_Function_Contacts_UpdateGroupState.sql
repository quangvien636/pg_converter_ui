-- ─── FUNCTION: contacts_updategroupstate ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_updategroupstate();
CREATE OR REPLACE FUNCTION public.contacts_updategroupstate(
) RETURNS void
AS $function$
BEGIN

	UPDATE ContactsGroup SET UseYn=State
	WHERE GroupNo = GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
