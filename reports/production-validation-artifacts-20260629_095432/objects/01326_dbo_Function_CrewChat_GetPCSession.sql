-- ─── FUNCTION: crewchat_getpcsession ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getpcsession();
CREATE OR REPLACE FUNCTION public.crewchat_getpcsession(
) RETURNS TABLE(
    sessionno text,
    userno text,
    sessionid text,
    deviceno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT SessionNo, UserNo, SessionID, DeviceNo
	FROM CrewChat_PCSessions
	WHERE SessionID = SessionID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
