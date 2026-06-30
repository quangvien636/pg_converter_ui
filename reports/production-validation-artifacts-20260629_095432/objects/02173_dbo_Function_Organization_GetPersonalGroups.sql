-- ─── FUNCTION: organization_getpersonalgroups ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getpersonalgroups(integer);
CREATE OR REPLACE FUNCTION public.organization_getpersonalgroups(
    userno integer
) RETURNS TABLE(
    groupno text,
    userno text,
    moddate text,
    name text,
    sortno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT GroupNo, UserNo, ModDate, Name, SortNo
	FROM Organization_PersonalGroups
	WHERE UserNo = organization_getpersonalgroups.userno
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
