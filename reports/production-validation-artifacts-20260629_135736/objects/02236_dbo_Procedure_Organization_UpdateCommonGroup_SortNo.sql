-- ─── PROCEDURE→FUNCTION: organization_updatecommongroup_sortno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updatecommongroup_sortno(bigint, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.organization_updatecommongroup_sortno(
    IN groupno bigint,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN sortno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_CommonGroups SET
		ModUserNo = organization_updatecommongroup_sortno.moduserno,
		ModDate = organization_updatecommongroup_sortno.moddate,
		SortNo = organization_updatecommongroup_sortno.sortno
	WHERE GroupNo = organization_updatecommongroup_sortno.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
