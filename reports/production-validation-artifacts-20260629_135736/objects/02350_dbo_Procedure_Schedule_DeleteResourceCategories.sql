-- ─── PROCEDURE→FUNCTION: schedule_deleteresourcecategories ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deleteresourcecategories(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteresourcecategories(
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleResourceCategories
	ModUserNo := schedule_deleteresourcecategories.userno,;
		ModDate = NOW(),
		Enabled = FALSE
	WHERE CategoryNo = CategoryNo
	
	UPDATE ScheduleResources
	SET 
		Enabled = FALSE
	WHERE CategoryNo = CategoryNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
