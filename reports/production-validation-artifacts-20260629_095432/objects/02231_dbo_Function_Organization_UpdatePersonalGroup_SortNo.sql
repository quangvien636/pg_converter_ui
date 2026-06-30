-- ─── FUNCTION: organization_updatepersonalgroup_sortno ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updatepersonalgroup_sortno(bigint, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.organization_updatepersonalgroup_sortno(
    groupno bigint,
    moddate timestamp without time zone,
    sortno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_PersonalGroups SET
		ModDate = organization_updatepersonalgroup_sortno.moddate,
		SortNo = organization_updatepersonalgroup_sortno.sortno
	WHERE GroupNo = organization_updatepersonalgroup_sortno.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
