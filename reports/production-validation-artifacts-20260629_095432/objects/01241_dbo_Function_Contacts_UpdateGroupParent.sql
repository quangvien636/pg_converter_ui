-- ─── FUNCTION: contacts_updategroupparent ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_updategroupparent(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updategroupparent(
    boxno integer,
    parentno integer
) RETURNS void
AS $function$
BEGIN
	UPDATE ContactsGroup SET ParentGNo=contacts_updategroupparent.parentno 
	WHERE GroupNo=contacts_updategroupparent.boxno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
