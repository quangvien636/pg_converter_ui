-- ─── FUNCTION: center_insertmobilesession_all ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertmobilesession_all(integer, character varying, bigint);
CREATE OR REPLACE FUNCTION public.center_insertmobilesession_all(
    userno integer,
    sessionid character varying,
    deviceno bigint
) RETURNS TABLE(
    sessionno text
)
AS $function$
DECLARE
    sessionno bigint;
BEGIN


	INSERT INTO Center_MobileSessions (UserNo, SessionID, DeviceNo)
	VALUES (UserNo, SessionID, DeviceNo)
	

	SET SessionNo = lastval()
	
	RETURN QUERY
	SELECT SessionNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
