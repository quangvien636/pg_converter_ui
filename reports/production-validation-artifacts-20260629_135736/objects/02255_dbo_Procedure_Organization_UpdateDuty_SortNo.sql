-- ─── PROCEDURE→FUNCTION: organization_updateduty_sortno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updateduty_sortno(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.organization_updateduty_sortno(
    IN dutyno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN sortno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Duties SET
		ModUserNo = organization_updateduty_sortno.moduserno,
		ModDate = organization_updateduty_sortno.moddate,
		SortNo = organization_updateduty_sortno.sortno
	WHERE DutyNo = organization_updateduty_sortno.dutyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
