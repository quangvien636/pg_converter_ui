-- ─── FUNCTION: schedule_getviewcalendarsubopen ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getviewcalendarsubopen();
CREATE OR REPLACE FUNCTION public.schedule_getviewcalendarsubopen(
) RETURNS TABLE(
    issubcompanyopen text,
    issubpersonalopen text,
    issubshareopen text,
    issubworktodoopen text
)
AS $function$
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
