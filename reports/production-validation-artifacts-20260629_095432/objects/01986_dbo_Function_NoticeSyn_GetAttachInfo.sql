-- ─── FUNCTION: noticesyn_getattachinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getattachinfo(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getattachinfo(
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
	SELECT AttachNo,NoticeNo,FileName,FileLength,FilePath FROM NoticeSyn_Attachments
	WHERE AttachNo = noticesyn_getattachinfo.attachno
END;
-------------------------------////////////////////////////////////////////------------
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
