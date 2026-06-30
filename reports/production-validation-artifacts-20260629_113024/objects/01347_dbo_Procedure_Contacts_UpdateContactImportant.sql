-- ─── PROCEDURE→FUNCTION: contacts_updatecontactimportant ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_updatecontactimportant(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updatecontactimportant(
    IN seq integer,
    IN important integer
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
