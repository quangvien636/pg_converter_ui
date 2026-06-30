-- ─── PROCEDURE→FUNCTION: organization_updateposition_name_vn ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updateposition_name_vn(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updateposition_name_vn(
    IN positionno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone
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
