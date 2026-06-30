-- ─── FUNCTION: notice_getcontentimg ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getcontentimg(integer);
CREATE OR REPLACE FUNCTION public.notice_getcontentimg(
    noticeno integer
) RETURNS TABLE(
    contentimgno text,
    noticeno text,
    filename text,
    filesize text,
    path text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT ContentImgNo,NoticeNo,FileName,FileSize,Path FROM NoticeContentImgs
	WHERE NoticeNo=notice_getcontentimg.noticeno
	ORDER BY ContentImgNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
