-- ─── FUNCTION: organization_updateposition_name ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updateposition_name(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updateposition_name(
    positionno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Positions SET
		ModUserNo = organization_updateposition_name.moduserno,
		ModDate = organization_updateposition_name.moddate,
		Name = Name
	WHERE PositionNo = organization_updateposition_name.positionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
