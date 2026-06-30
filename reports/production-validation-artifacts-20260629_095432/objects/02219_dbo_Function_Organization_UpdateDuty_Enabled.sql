-- ─── FUNCTION: organization_updateduty_enabled ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updateduty_enabled(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.organization_updateduty_enabled(
    dutyno integer,
    moduserno integer,
    moddate timestamp without time zone,
    enabled boolean
) RETURNS TABLE(
    sortno text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    _dutyno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF (Enabled = FALSE) BEGIN


		RETURN QUERY
		SELECT /* TOP 1 */ _DutyNo = organization_updateduty_enabled.dutyno
		FROM Organization_Duties
		WHERE Enabled = TRUE AND SortNo < (SELECT SortNo FROM Organization_Duties WHERE DutyNo = organization_updateduty_enabled.dutyno)
		ORDER BY SortNo DESC

		IF (_DutyNo IS NULL) BEGIN

			RETURN QUERY
			SELECT /* TOP 1 */ _DutyNo = organization_updateduty_enabled.dutyno
			FROM Organization_Duties
			WHERE Enabled = TRUE AND SortNo > (SELECT SortNo FROM Organization_Duties WHERE DutyNo = organization_updateduty_enabled.dutyno)
			ORDER BY SortNo ASC

		END

		UPDATE Organization_BelongToDepartment SET DutyNo = _DutyNo WHERE DutyNo = organization_updateduty_enabled.dutyno

	END

	UPDATE Organization_Duties SET
		ModUserNo = organization_updateduty_enabled.moduserno,
		ModDate = organization_updateduty_enabled.moddate,
		Enabled = organization_updateduty_enabled.enabled
	WHERE DutyNo = organization_updateduty_enabled.dutyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
