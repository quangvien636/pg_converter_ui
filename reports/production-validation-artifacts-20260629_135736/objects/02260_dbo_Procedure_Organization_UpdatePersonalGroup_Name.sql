-- ─── PROCEDURE→FUNCTION: organization_updatepersonalgroup_name ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updatepersonalgroup_name(bigint, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updatepersonalgroup_name(
    IN groupno bigint,
    IN moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_PersonalGroups SET
		ModDate = organization_updatepersonalgroup_name.moddate,
		Name = Name
	WHERE GroupNo = organization_updatepersonalgroup_name.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
