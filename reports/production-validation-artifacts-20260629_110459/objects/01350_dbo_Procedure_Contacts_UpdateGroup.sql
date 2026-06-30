-- ─── PROCEDURE→FUNCTION: contacts_updategroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_updategroup(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updategroup(
    IN reguserno integer,
    IN groupno integer
) RETURNS void
AS $function$
BEGIN
	UPDATE ContactsGroup SET GroupName=GroupName 
	WHERE GroupNo=contacts_updategroup.groupno AND RegUserNo = contacts_updategroup.reguserno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
