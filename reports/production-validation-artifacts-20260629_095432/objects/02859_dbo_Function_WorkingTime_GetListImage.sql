-- ─── FUNCTION: workingtime_getlistimage ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getlistimage(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlistimage(
    userno integer
) RETURNS TABLE(
    imageno text,
    userno text,
    col3 text,
    urlimage text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT ImageNo,UserNo,DateUpload = CONVERT(char(10), DateUpload,126) + ' ' || CONVERT(char(5), DateUpload, 108),UrlImage FROM WorkingTime_Images
	WHERE CONVERT(CHAR(10), DateUpload,126) = DateUpload and UserNo = workingtime_getlistimage.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
