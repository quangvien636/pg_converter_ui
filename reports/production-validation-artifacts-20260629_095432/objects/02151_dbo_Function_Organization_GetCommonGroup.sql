-- ─── FUNCTION: organization_getcommongroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getcommongroup(bigint);
CREATE OR REPLACE FUNCTION public.organization_getcommongroup(
    groupno bigint
) RETURNS TABLE(
    moduserno text,
    moddate text,
    name text,
    sortno text,
    listofusers text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ModUserNo, ModDate, Name, SortNo, ListOfUsers
	FROM Organization_CommonGroups
	WHERE GroupNo = organization_getcommongroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
