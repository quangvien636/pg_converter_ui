-- ─── PROCEDURE→FUNCTION: contacts_updategroupparent ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_updategroupparent(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updategroupparent(
    IN boxno integer,
    IN parentno integer
) RETURNS void
AS $function$
BEGIN
	UPDATE ContactsGroup SET ParentGNo=contacts_updategroupparent.parentno 
	WHERE GroupNo=contacts_updategroupparent.boxno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
