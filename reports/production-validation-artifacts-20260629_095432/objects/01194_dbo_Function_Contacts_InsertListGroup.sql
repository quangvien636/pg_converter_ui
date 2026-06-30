-- ─── FUNCTION: contacts_insertlistgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_insertlistgroup(integer);
CREATE OR REPLACE FUNCTION public.contacts_insertlistgroup(
    listgroup_id integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	IF ListGroup_Id=0
		BEGIN;
			INSERT INTO Contacts_ListGroup(ListGroup_Content,ListGroup_RegDate,ListGroup_ModDate)
			VALUES(ListGroup_Content,NOW(),NOW())
			SET ListGroup_Id = lastval()
			RETURN QUERY
			SELECT ListGroup_Id AS ListGroup_Id
		END
	ELSE
		BEGIN;
			UPDATE Contacts_ListGroup
			SET ListGroup_Content=ListGroup_Content,ListGroup_ModDate=NOW()
			WHERE ListGroup_Id=contacts_insertlistgroup.listgroup_id
			RETURN QUERY
			SELECT ListGroup_Id AS ListGroup_Id
		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
