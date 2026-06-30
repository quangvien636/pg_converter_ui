-- ─── FUNCTION: crewchat_deleteattachfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_deleteattachfile(integer);
CREATE OR REPLACE FUNCTION public.crewchat_deleteattachfile(
    attachno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_Attach WHERE AttachNo = crewchat_deleteattachfile.attachno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
