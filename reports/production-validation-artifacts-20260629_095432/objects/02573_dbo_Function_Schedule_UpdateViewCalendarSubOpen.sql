-- ─── FUNCTION: schedule_updateviewcalendarsubopen ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateviewcalendarsubopen(integer, boolean);
CREATE OR REPLACE FUNCTION public.schedule_updateviewcalendarsubopen(
    type integer,
    isopen boolean
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.


    -- INSERT INTO statements for procedure here
	IF Type = 1
	BEGIN;
		UPDATE  ScheduleViewCalendars
		SET
			IsSubCompanyOpen = schedule_updateviewcalendarsubopen.isopen
		WHERE UserNo = UserNo
	END
	IF Type = 2
	BEGIN;
		UPDATE  ScheduleViewCalendars
		SET
			IsSubPersonalOpen = schedule_updateviewcalendarsubopen.isopen
		WHERE UserNo = UserNo
	END
	IF Type = 3
	BEGIN;
		UPDATE  ScheduleViewCalendars
		SET
			IsSubShareOpen = schedule_updateviewcalendarsubopen.isopen
		WHERE UserNo = UserNo
	END
	IF Type = 4
	BEGIN;
		UPDATE  ScheduleViewCalendars
		SET
			IsSubWorkToDoOpen = schedule_updateviewcalendarsubopen.isopen
		WHERE UserNo = UserNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
