-- ─── FUNCTION: crewchat_getattachfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getattachfile(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getattachfile(
    attachno integer
) RETURNS void
AS $function$
BEGIN

    -- INSERT INTO statements for procedure here
	SELECT AttachNo, FileName, FullPath, Type, Size, ThumbWidth, ThumbHeight FROM CrewChat_Attach
	WHERE AttachNo = crewchat_getattachfile.attachno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
