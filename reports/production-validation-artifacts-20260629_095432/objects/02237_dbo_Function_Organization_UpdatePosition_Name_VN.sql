-- ─── FUNCTION: organization_updateposition_name_vn ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updateposition_name_vn(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updateposition_name_vn(
    positionno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Positions SET
		ModUserNo = organization_updateposition_name_vn.moduserno,
		ModDate = organization_updateposition_name_vn.moddate,
		Name_VN = Name_VN
	WHERE PositionNo = organization_updateposition_name_vn.positionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
