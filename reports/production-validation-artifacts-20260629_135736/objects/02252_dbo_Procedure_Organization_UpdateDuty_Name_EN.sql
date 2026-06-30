-- ─── PROCEDURE→FUNCTION: organization_updateduty_name_en ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updateduty_name_en(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updateduty_name_en(
    IN dutyno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Duties SET
		ModUserNo = organization_updateduty_name_en.moduserno,
		ModDate = organization_updateduty_name_en.moddate,
		Name_EN = Name_EN
	WHERE DutyNo = organization_updateduty_name_en.dutyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
