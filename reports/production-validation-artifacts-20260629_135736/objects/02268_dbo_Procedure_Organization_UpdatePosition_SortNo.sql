-- ─── PROCEDURE→FUNCTION: organization_updateposition_sortno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updateposition_sortno(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.organization_updateposition_sortno(
    IN positionno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN sortno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Positions SET
		ModUserNo = organization_updateposition_sortno.moduserno,
		ModDate = organization_updateposition_sortno.moddate,
		SortNo = organization_updateposition_sortno.sortno
	WHERE PositionNo = organization_updateposition_sortno.positionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
