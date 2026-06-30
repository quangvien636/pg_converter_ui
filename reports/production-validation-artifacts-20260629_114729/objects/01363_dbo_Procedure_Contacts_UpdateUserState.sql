-- ─── PROCEDURE→FUNCTION: contacts_updateuserstate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
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
