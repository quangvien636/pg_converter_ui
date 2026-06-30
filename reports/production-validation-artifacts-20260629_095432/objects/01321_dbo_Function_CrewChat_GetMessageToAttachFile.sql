-- ─── FUNCTION: crewchat_getmessagetoattachfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getmessagetoattachfile(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getmessagetoattachfile(
    attachno integer
) RETURNS TABLE(
    messageno text,
    type text,
    regdate text
)
AS $function$
BEGIN

	
	RETURN QUERY
	SELECT MessageNo, Type, RegDate
	FROM CrewChat_Messages
	WHERE AttachNo = crewchat_getmessagetoattachfile.attachno
	ORDER BY RegDate ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
