-- ─── FUNCTION: organization_updateposition_name_ch ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updateposition_name_ch(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updateposition_name_ch(
    positionno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Positions SET
		ModUserNo = organization_updateposition_name_ch.moduserno,
		ModDate = organization_updateposition_name_ch.moddate,
		Name_CH = Name_CH
	WHERE PositionNo = organization_updateposition_name_ch.positionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
