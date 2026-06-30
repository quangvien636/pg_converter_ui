-- ─── FUNCTION: organization_updateposition_sortno ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updateposition_sortno(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.organization_updateposition_sortno(
    positionno integer,
    moduserno integer,
    moddate timestamp without time zone,
    sortno integer
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
