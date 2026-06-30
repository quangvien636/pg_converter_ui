-- ─── PROCEDURE→FUNCTION: schedule_updateviewcalendarsubopen ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_updateviewcalendarsubopen(integer, boolean);
CREATE OR REPLACE FUNCTION public.schedule_updateviewcalendarsubopen(
    IN type integer,
    IN isopen boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    -- INSERT INTO statements for procedure here
	IF Type = 1 THEN;
		UPDATE  ScheduleViewCalendars
		IsSubCompanyOpen := schedule_updateviewcalendarsubopen.isopen;
		WHERE UserNo = UserNo
	END IF;
	IF Type = 2 THEN;
		UPDATE  ScheduleViewCalendars
		IsSubPersonalOpen := schedule_updateviewcalendarsubopen.isopen;
		WHERE UserNo = UserNo
	END IF;
	IF Type = 3 THEN;
		UPDATE  ScheduleViewCalendars
		IsSubShareOpen := schedule_updateviewcalendarsubopen.isopen;
		WHERE UserNo = UserNo
	END IF;
	IF Type = 4 THEN;
		UPDATE  ScheduleViewCalendars
		IsSubWorkToDoOpen := schedule_updateviewcalendarsubopen.isopen;
		WHERE UserNo = UserNo
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
