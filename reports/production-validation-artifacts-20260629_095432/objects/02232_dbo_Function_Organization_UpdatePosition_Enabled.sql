-- ─── FUNCTION: organization_updateposition_enabled ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updateposition_enabled(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.organization_updateposition_enabled(
    positionno integer,
    moduserno integer,
    moddate timestamp without time zone,
    enabled boolean
) RETURNS TABLE(
    sortno text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    _positionno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF (Enabled = FALSE) BEGIN


		RETURN QUERY
		SELECT /* TOP 1 */ _PositionNo = organization_updateposition_enabled.positionno
		FROM Organization_Positions
		WHERE Enabled = TRUE AND SortNo < (SELECT SortNo FROM Organization_Positions WHERE PositionNo = organization_updateposition_enabled.positionno)
		ORDER BY SortNo DESC

		IF (_PositionNo IS NULL) BEGIN

			RETURN QUERY
			SELECT /* TOP 1 */ _PositionNo = organization_updateposition_enabled.positionno
			FROM Organization_Positions
			WHERE Enabled = TRUE AND SortNo > (SELECT SortNo FROM Organization_Positions WHERE PositionNo = organization_updateposition_enabled.positionno)
			ORDER BY SortNo ASC

		END

		UPDATE Organization_BelongToDepartment SET PositionNo = _PositionNo WHERE PositionNo = organization_updateposition_enabled.positionno

	END

	UPDATE Organization_Positions SET
		ModUserNo = organization_updateposition_enabled.moduserno,
		ModDate = organization_updateposition_enabled.moddate,
		Enabled = organization_updateposition_enabled.enabled
	WHERE PositionNo = organization_updateposition_enabled.positionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
