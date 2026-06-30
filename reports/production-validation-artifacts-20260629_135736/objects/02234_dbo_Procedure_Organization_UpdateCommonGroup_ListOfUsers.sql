-- ─── PROCEDURE→FUNCTION: organization_updatecommongroup_listofusers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updatecommongroup_listofusers(bigint, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updatecommongroup_listofusers(
    IN groupno bigint,
    IN moduserno integer,
    IN moddate timestamp without time zone
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
