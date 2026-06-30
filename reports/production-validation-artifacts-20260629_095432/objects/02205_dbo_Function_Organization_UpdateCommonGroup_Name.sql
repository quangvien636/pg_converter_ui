-- ─── FUNCTION: organization_updatecommongroup_name ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updatecommongroup_name(bigint, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updatecommongroup_name(
    groupno bigint,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_CommonGroups SET
		ModUserNo = organization_updatecommongroup_name.moduserno,
		ModDate = organization_updatecommongroup_name.moddate,
		Name = Name
	WHERE GroupNo = organization_updatecommongroup_name.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
