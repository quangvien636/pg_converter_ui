-- ─── PROCEDURE→FUNCTION: contacts_updatelistgroupcontact ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_updatelistgroupcontact(integer);
CREATE OR REPLACE FUNCTION public.contacts_updatelistgroupcontact(
    IN contactid integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ContactsUser
	GroupList := GroupList;
	WHERE Seq=contacts_updatelistgroupcontact.contactid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
