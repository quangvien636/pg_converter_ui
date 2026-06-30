-- ─── PROCEDURE→FUNCTION: contacts_setcallphone ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_setcallphone(integer);
CREATE OR REPLACE FUNCTION public.contacts_setcallphone(
    IN seq integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ContactsNumber
	SetCall := 1;
	WHERE Seq=contacts_setcallphone.seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
