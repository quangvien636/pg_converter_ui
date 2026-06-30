-- ─── FUNCTION: workingtime_addimageupload ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_addimageupload(integer);
CREATE OR REPLACE FUNCTION public.workingtime_addimageupload(
    userno integer
) RETURNS void
AS $function$
BEGIN

    INSERT INTO WorkingTime_Images(UserNo,DateUpload,UrlImage)
	VALUES(UserNo,NOW(),url);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
