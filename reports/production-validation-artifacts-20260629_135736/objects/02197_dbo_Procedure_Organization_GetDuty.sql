-- ─── PROCEDURE→FUNCTION: organization_getduty ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getduty(integer);
CREATE OR REPLACE FUNCTION public.organization_getduty(
    IN dutyno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT DutyNo, ModUserNo, ModDate, Name, Name_EN, SortNo, Enabled
	,Name_CH,Name_JP,Name_VN
	FROM Organization_Duties
	WHERE DutyNo = organization_getduty.dutyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
