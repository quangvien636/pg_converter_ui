-- ─── FUNCTION: noticesyn_getfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getfiles(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getfiles(
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
	SELECT AttachNo,FileName,FileLength,FilePath FROM NoticeSyn_Attachments
	WHERE NoticeNo=noticesyn_getfiles.noticeno
	ORDER BY AttachNo
END;
---------------------------//////////////////////////----------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
