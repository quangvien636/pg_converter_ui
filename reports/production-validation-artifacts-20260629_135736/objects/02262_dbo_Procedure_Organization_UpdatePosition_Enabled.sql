-- ─── PROCEDURE→FUNCTION: organization_updateposition_enabled ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.organization_updateposition_enabled(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.organization_updateposition_enabled(
    IN positionno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN enabled boolean
) RETURNS SETOF record
AS $function$
DECLARE
    _positionno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF Enabled = FALSE THEN


		RETURN QUERY
		SELECT /* TOP 1 */ _PositionNo = organization_updateposition_enabled.positionno
		FROM Organization_Positions
		WHERE Enabled = TRUE AND SortNo < (SELECT SortNo FROM Organization_Positions WHERE PositionNo = organization_updateposition_enabled.positionno)
		ORDER BY SortNo DESC

		IF _PositionNo IS NULL THEN

			RETURN QUERY
			SELECT /* TOP 1 */ _PositionNo = organization_updateposition_enabled.positionno
			FROM Organization_Positions
			WHERE Enabled = TRUE AND SortNo > (SELECT SortNo FROM Organization_Positions WHERE PositionNo = organization_updateposition_enabled.positionno)
			ORDER BY SortNo ASC

		END IF;

		UPDATE Organization_BelongToDepartment SET PositionNo = _PositionNo WHERE PositionNo = organization_updateposition_enabled.positionno

	END IF;

	UPDATE Organization_Positions SET
		ModUserNo = organization_updateposition_enabled.moduserno,
		ModDate = organization_updateposition_enabled.moddate,
		Enabled = organization_updateposition_enabled.enabled
	WHERE PositionNo = organization_updateposition_enabled.positionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
