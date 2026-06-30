-- ─── FUNCTION: organization_updatecommongroup_listofusers ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updatecommongroup_listofusers(bigint, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updatecommongroup_listofusers(
    groupno bigint,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_CommonGroups SET
		ModUserNo = organization_updatecommongroup_listofusers.moduserno,
		ModDate = organization_updatecommongroup_listofusers.moddate,
		ListOfUsers = ListOfUsers
	WHERE GroupNo = organization_updatecommongroup_listofusers.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
