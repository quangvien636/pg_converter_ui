-- ─── FUNCTION: schedule_deletedivisioncheck ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deletedivisioncheck();
CREATE OR REPLACE FUNCTION public.schedule_deletedivisioncheck(
) RETURNS void
AS $function$
BEGIN


    -- INSERT INTO statements for procedure here
	SELECT COUNT(DivisionNo) AS DelCheck From ScheduleContents
	WHERE DivisionNo IN (SELECT VALUE FROM public."UF_TEXT_SPLIT"(DivisionNo,','));
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
