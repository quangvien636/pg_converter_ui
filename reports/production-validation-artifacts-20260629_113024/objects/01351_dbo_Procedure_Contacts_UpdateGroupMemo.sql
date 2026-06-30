-- ─── PROCEDURE→FUNCTION: contacts_updategroupmemo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_updategroupmemo(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updategroupmemo(
    IN groupno integer,
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ContactsGroup SET Memo = Memo 
	WHERE GroupNo = contacts_updategroupmemo.groupno 
	AND RegUserNo = contacts_updategroupmemo.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
