-- ─── FUNCTION: organization_insertcommongroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_insertcommongroup(integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_insertcommongroup(
    moduserno integer,
    moddate timestamp without time zone
) RETURNS TABLE(
    groupno text
)
AS $function$
DECLARE
    groupno bigint;
BEGIN


	UPDATE Organization_CommonGroups SET SortNo = SortNo + 1

	INSERT INTO Organization_CommonGroups (ModUserNo, ModDate, Name, SortNo, ListOfUsers)
	VALUES (ModUserNo, ModDate, Name, 1, '')


	SET GroupNo = lastval()

	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
