-- ─── FUNCTION: center_insertfailedloginlogs ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertfailedloginlogs(integer, character varying, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.center_insertfailedloginlogs(
    userno integer,
    clientip character varying,
    failedlogindate timestamp without time zone
) RETURNS TABLE(
    logno text
)
AS $function$
DECLARE
    logno bigint;
BEGIN


	INSERT INTO Center_FailedLoginLogs (UserNo, ClientIP, FailedLoginDate)
	VALUES (UserNo, ClientIP, FailedLoginDate)
	

	SET LogNo = lastval()
	
	RETURN QUERY
	SELECT LogNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
