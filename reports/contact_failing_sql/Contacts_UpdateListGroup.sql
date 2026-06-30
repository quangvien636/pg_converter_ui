-- ─── PROCEDURE→FUNCTION: contacts_updatelistgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_updatelistgroup(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updatelistgroup(
    IN type integer,
    IN contactid integer,
    IN listgroup_id integer
) RETURNS void
AS $function$
BEGIN

	IF Type=1 THEN
			DELETE FROM Contacts_ListGroupContact WHERE ListGroupContact_ContactId=contacts_updatelistgroup.contactid;
			DELETE FROM Contacts_ListGroup WHERE ListGroup_Id=contacts_updatelistgroup.listgroup_id
	ELSE
		BEGIN
			UPDATE Contacts_ListGroup
			SET ListGroup_Content=ListGroup_Content
			WHERE ListGroup_Id=contacts_updatelistgroup.listgroup_id
		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.