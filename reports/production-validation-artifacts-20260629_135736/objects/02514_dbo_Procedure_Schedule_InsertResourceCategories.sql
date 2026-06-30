-- ─── PROCEDURE→FUNCTION: schedule_insertresourcecategories ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertresourcecategories(integer);
CREATE OR REPLACE FUNCTION public.schedule_insertresourcecategories(
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	INSERT INTO ScheduleResourceCategories
	(
		Name,
		Enabled,
		RegUserNo,
		RegDate,
		ModUserNo,
		ModDate
	)
	VALUES
	(
		Name,
		1,
		UserNo,
		NOW(),
		UserNo,
		NOW()
	);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
