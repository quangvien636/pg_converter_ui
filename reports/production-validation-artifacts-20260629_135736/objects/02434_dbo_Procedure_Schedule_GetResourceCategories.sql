-- ─── PROCEDURE→FUNCTION: schedule_getresourcecategories ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourcecategories(boolean);
CREATE OR REPLACE FUNCTION public.schedule_getresourcecategories(
    IN enabled boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF Enabled = TRUE THEN

		RETURN QUERY
		SELECT CategoryNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, Enabled
		FROM ScheduleResourceCategories
		WHERE Enabled = TRUE
	
	END IF;
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT CategoryNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, Enabled
		FROM ScheduleResourceCategories
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
