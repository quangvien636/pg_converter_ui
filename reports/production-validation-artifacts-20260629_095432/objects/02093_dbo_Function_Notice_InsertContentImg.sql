-- ─── FUNCTION: notice_insertcontentimg ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_insertcontentimg(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.notice_insertcontentimg(
    noticeno integer,
    filename character varying,
    filesize integer
) RETURNS TABLE(
    contentimgno text
)
AS $function$
DECLARE
    contentimgno integer;
BEGIN

	INSERT INTO NoticeContentImgs
	(NoticeNo,FileName,FileSize,Path)
	VALUES
	(NoticeNo, FileName, FileSize, Path)
	

	SET ContentImgNo = lastval()
	
	RETURN QUERY
	SELECT ContentImgNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
