-- ─── PROCEDURE→FUNCTION: contacts_delcontactsshare ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_delcontactsshare(integer);
CREATE OR REPLACE FUNCTION public.contacts_delcontactsshare(
    IN seq integer
) RETURNS void
AS $function$
BEGIN

	delete from ContactsSharers where Seq=contacts_delcontactsshare.seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
