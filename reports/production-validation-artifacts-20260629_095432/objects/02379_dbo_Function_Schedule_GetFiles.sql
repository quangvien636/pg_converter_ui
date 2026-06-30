-- ─── FUNCTION: schedule_getfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getfiles();
CREATE OR REPLACE FUNCTION public.schedule_getfiles(
) RETURNS TABLE(
    attachno text,
    scheduleno text,
    filename text,
    filelength text,
    filepath text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT 
		AttachNo,
		ScheduleNo,
		FileName,
		FileLength,
		FilePath
	FROM ScheduleContentsAttachments
	WHERE ScheduleNo = ScheduleNo
	ORDER BY AttachNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
