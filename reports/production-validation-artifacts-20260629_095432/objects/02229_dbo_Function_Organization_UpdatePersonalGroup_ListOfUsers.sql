-- ─── FUNCTION: organization_updatepersonalgroup_listofusers ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updatepersonalgroup_listofusers(bigint, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updatepersonalgroup_listofusers(
    groupno bigint,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_PersonalGroups SET
		ModDate = organization_updatepersonalgroup_listofusers.moddate,
		ListOfUsers = ListOfUsers
	WHERE GroupNo = organization_updatepersonalgroup_listofusers.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
