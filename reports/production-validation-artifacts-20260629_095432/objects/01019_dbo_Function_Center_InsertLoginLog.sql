-- ─── FUNCTION: center_insertloginlog ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertloginlog(integer, character varying, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.center_insertloginlog(
    userno integer,
    clientip character varying,
    logindate timestamp without time zone
) RETURNS TABLE(
    logno text
)
AS $function$
DECLARE
    logno bigint;
BEGIN


	INSERT INTO Center_AccessLogs(UserNo,ClientIP,AccessDate,ApplicationNo)
	VALUES(UserNo, ClientIP, LoginDate, -10)
	
	INSERT INTO Center_LoginLogs (UserNo, ClientIP, LoginDate)
	VALUES (UserNo, ClientIP, LoginDate)
	

	SET LogNo = lastval()
	
	RETURN QUERY
	SELECT LogNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
