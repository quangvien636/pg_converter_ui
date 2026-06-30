-- ─── PROCEDURE→FUNCTION: schedule_updateresourcecategories ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updateresourcecategories(character varying, integer, boolean);
CREATE OR REPLACE FUNCTION public.schedule_updateresourcecategories(
    IN name character varying,
    IN userno integer,
    IN enabled boolean DEFAULT 1 --값이 안넘어오면 기본적으로 활성화 처리
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleResourceCategories
	Name := schedule_updateresourcecategories.name,;
		ModUserNo = schedule_updateresourcecategories.userno,
		ModDate = NOW(),
		Enabled = schedule_updateresourcecategories.enabled
	WHERE CategoryNo = CategoryNo

	UPDATE ScheduleResources
	SET 
		Enabled = schedule_updateresourcecategories.enabled
	WHERE CategoryNo = CategoryNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
