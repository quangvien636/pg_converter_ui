-- ─── FUNCTION: schedule_getattachinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getattachinfo();
CREATE OR REPLACE FUNCTION public.schedule_getattachinfo(
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
	SELECT AttachNo,ScheduleNo,FileName,FileLength,FilePath FROM ScheduleContentsAttachments
	WHERE AttachNo = AttachNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
