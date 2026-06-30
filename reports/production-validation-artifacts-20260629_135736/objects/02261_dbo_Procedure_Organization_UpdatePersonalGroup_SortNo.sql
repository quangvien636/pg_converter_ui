-- ─── PROCEDURE→FUNCTION: organization_updatepersonalgroup_sortno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updatepersonalgroup_sortno(bigint, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.organization_updatepersonalgroup_sortno(
    IN groupno bigint,
    IN moddate timestamp without time zone,
    IN sortno integer
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
