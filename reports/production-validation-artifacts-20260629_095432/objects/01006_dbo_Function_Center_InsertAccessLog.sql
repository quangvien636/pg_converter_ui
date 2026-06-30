-- ─── FUNCTION: center_insertaccesslog ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertaccesslog(integer, character varying, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.center_insertaccesslog(
    userno integer,
    clientip character varying,
    accessdate timestamp without time zone,
    applicationno integer
) RETURNS TABLE(
    logno text
)
AS $function$
DECLARE
    logno bigint;
BEGIN


	INSERT INTO Center_AccessLogs (UserNo, ClientIP, AccessDate, ApplicationNo)
	VALUES (UserNo, ClientIP, AccessDate, ApplicationNo)
	

	SET LogNo = lastval()
	
	RETURN QUERY
	SELECT LogNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
