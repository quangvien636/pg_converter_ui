-- ─── PROCEDURE→FUNCTION: crewchat_getattachfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_getattachfile(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getattachfile(
    IN attachno integer
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
