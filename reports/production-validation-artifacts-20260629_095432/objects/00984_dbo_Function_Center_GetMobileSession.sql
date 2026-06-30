-- ─── FUNCTION: center_getmobilesession ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getmobilesession(character varying);
CREATE OR REPLACE FUNCTION public.center_getmobilesession(
    sessionid character varying DEFAULT 'AF09159542384847966E440C540FD844'
) RETURNS TABLE(
    sessionno text,
    userno text,
    deviceno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT SessionNo, UserNo, DeviceNo
	FROM Center_MobileSessions
	WHERE SessionID = center_getmobilesession.sessionid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
