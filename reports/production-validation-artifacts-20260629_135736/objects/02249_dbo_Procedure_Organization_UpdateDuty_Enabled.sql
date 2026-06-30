-- ─── PROCEDURE→FUNCTION: organization_updateduty_enabled ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.organization_updateduty_enabled(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.organization_updateduty_enabled(
    IN dutyno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN enabled boolean
) RETURNS SETOF record
AS $function$
DECLARE
    _dutyno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF Enabled = FALSE THEN


		RETURN QUERY
		SELECT /* TOP 1 */ _DutyNo = organization_updateduty_enabled.dutyno
		FROM Organization_Duties
		WHERE Enabled = TRUE AND SortNo < (SELECT SortNo FROM Organization_Duties WHERE DutyNo = organization_updateduty_enabled.dutyno)
		ORDER BY SortNo DESC

		IF _DutyNo IS NULL THEN

			RETURN QUERY
			SELECT /* TOP 1 */ _DutyNo = organization_updateduty_enabled.dutyno
			FROM Organization_Duties
			WHERE Enabled = TRUE AND SortNo > (SELECT SortNo FROM Organization_Duties WHERE DutyNo = organization_updateduty_enabled.dutyno)
			ORDER BY SortNo ASC

		END IF;

		UPDATE Organization_BelongToDepartment SET DutyNo = _DutyNo WHERE DutyNo = organization_updateduty_enabled.dutyno

	END IF;

	UPDATE Organization_Duties SET
		ModUserNo = organization_updateduty_enabled.moduserno,
		ModDate = organization_updateduty_enabled.moddate,
		Enabled = organization_updateduty_enabled.enabled
	WHERE DutyNo = organization_updateduty_enabled.dutyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
