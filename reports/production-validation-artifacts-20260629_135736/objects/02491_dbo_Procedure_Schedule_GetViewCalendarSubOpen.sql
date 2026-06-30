-- ─── PROCEDURE→FUNCTION: schedule_getviewcalendarsubopen ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getviewcalendarsubopen();
CREATE OR REPLACE FUNCTION public.schedule_getviewcalendarsubopen(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    -- INSERT INTO statements for procedure here
	RETURN QUERY
	SELECT 
		COALESCE(IsSubCompanyOpen, 1) AS IsSubCompanyOpen,
		COALESCE(IsSubPersonalOpen, 1) AS IsSubPersonalOpen,
		COALESCE(IsSubShareOpen, 1) AS IsSubShareOpen,
		COALESCE(IsSubWorkToDoOpen, 1) AS IsSubWorkToDoOpen
	FROM ScheduleViewCalendars
	WHERE UserNo = UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
