-- ─── FUNCTION: notice_getattachinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getattachinfo(integer);
CREATE OR REPLACE FUNCTION public.notice_getattachinfo(
    attachno integer
) RETURNS TABLE(
    attachno text,
    noticeno text,
    filename text,
    filelength text,
    filepath text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT AttachNo,NoticeNo,FileName,FileLength,FilePath FROM NoticeAttachments
	WHERE AttachNo = notice_getattachinfo.attachno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
