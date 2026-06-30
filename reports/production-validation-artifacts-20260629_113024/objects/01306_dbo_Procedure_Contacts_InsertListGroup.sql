-- ─── PROCEDURE→FUNCTION: contacts_insertlistgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_insertlistgroup(integer);
CREATE OR REPLACE FUNCTION public.contacts_insertlistgroup(
    IN listgroup_id integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF ListGroup_Id=0 THEN;
			INSERT INTO Contacts_ListGroup(ListGroup_Content,ListGroup_RegDate,ListGroup_ModDate)
			VALUES(ListGroup_Content,NOW(),NOW())
			ListGroup_Id := lastval();
			RETURN QUERY
			SELECT ListGroup_Id AS ListGroup_Id
		END IF;
	ELSE;
			UPDATE Contacts_ListGroup
			ListGroup_Content := ListGroup_Content,ListGroup_ModDate=NOW();
			WHERE ListGroup_Id=contacts_insertlistgroup.listgroup_id
			RETURN QUERY
			SELECT ListGroup_Id AS ListGroup_Id
		END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
