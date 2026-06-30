-- ─── FUNCTION: noticesyn_insertcontentimg ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_insertcontentimg(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_insertcontentimg(
    noticeno integer,
    filename character varying,
    filesize integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    contentimgno integer;
BEGIN

	INSERT INTO NoticeSyn_ContentImgs
	(NoticeNo,FileName,FileSize,Path)
	VALUES
	(NoticeNo, FileName, FileSize, Path)
	

	SET ContentImgNo = lastval()
	
	RETURN QUERY
	SELECT ContentImgNo
END;
-------------------------- -----------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
