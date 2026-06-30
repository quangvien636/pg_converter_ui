-- ─── FUNCTION: notice_getfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getfiles(integer);
CREATE OR REPLACE FUNCTION public.notice_getfiles(
    noticeno integer
) RETURNS TABLE(
    attachno text,
    filename text,
    filelength text,
    filepath text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT AttachNo,FileName,FileLength,FilePath FROM NoticeAttachments
	WHERE NoticeNo=notice_getfiles.noticeno
	ORDER BY --COALESCE(Sort,0) ASC, 
	AttachNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
