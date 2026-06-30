-- ─── FUNCTION: organization_getcommongroups ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getcommongroups();
CREATE OR REPLACE FUNCTION public.organization_getcommongroups(
) RETURNS TABLE(
    groupno text,
    moduserno text,
    moddate text,
    name text,
    sortno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT GroupNo, ModUserNo, ModDate, Name, SortNo
	FROM Organization_CommonGroups
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
