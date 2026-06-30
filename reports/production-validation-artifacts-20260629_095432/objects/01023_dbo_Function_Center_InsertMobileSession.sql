-- ─── FUNCTION: center_insertmobilesession ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertmobilesession(integer, bigint);
CREATE OR REPLACE FUNCTION public.center_insertmobilesession(
    userno integer,
    deviceno bigint
) RETURNS TABLE(
    sessionno text,
    sessionid text
)
AS $function$
DECLARE
    sessionno bigint;
BEGIN


	INSERT INTO Center_MobileSessions (UserNo, SessionID, DeviceNo)
	VALUES (UserNo, REPLACE(NEWID(), '-', ''), DeviceNo)
	

	SET SessionNo = lastval()
	
	RETURN QUERY
	SELECT SessionNo, SessionID
	FROM Center_MobileSessions
	WHERE SessionNo = SessionNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
