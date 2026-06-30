-- ─── FUNCTION: center_getaccesslogs ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getaccesslogs(integer);
CREATE OR REPLACE FUNCTION public.center_getaccesslogs(
    userno integer
) RETURNS TABLE(
    logno text,
    userno text,
    clientip text,
    accessdate text,
    applicationno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT LogNo, UserNo, ClientIP, AccessDate, ApplicationNo
	FROM Center_AccessLogs
	WHERE UserNo = center_getaccesslogs.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
