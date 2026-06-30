-- ─── FUNCTION: noticesyn_getcontentimg ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getcontentimg(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getcontentimg(
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
	SELECT ContentImgNo,NoticeNo,FileName,FileSize,Path FROM NoticeSyn_ContentImgs
	WHERE NoticeNo=noticesyn_getcontentimg.noticeno
	ORDER BY ContentImgNo
END;
--------------------------------------////////////////////////////////------------
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
