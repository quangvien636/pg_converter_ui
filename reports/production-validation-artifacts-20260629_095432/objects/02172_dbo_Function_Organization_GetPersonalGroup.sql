-- ─── FUNCTION: organization_getpersonalgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getpersonalgroup(bigint);
CREATE OR REPLACE FUNCTION public.organization_getpersonalgroup(
    groupno bigint
) RETURNS TABLE(
    userno text,
    moddate text,
    name text,
    sortno text,
    listofusers text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT UserNo, ModDate, Name, SortNo, ListOfUsers
	FROM Organization_PersonalGroups
	WHERE GroupNo = organization_getpersonalgroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
