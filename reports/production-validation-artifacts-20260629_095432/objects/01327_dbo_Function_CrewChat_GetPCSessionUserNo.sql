-- ─── FUNCTION: crewchat_getpcsessionuserno ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getpcsessionuserno(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getpcsessionuserno(
    userno integer
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
	WHERE UserNo = crewchat_getpcsessionuserno.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
