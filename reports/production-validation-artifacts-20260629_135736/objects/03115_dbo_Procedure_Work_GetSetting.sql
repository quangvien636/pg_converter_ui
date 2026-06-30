-- ─── PROCEDURE→FUNCTION: work_getsetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getsetting(integer);
CREATE OR REPLACE FUNCTION public.work_getsetting(
    IN settingno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT SettingNo, RegUserNo, RegDate, ModUserNo, ModDate, SettingValue
	FROM WorkSettings
	WHERE SettingNo = work_getsetting.settingno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
