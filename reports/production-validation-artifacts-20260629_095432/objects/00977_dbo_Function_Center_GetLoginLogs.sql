-- ─── FUNCTION: center_getloginlogs ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getloginlogs(integer);
CREATE OR REPLACE FUNCTION public.center_getloginlogs(
    userno integer
) RETURNS TABLE(
    logno text,
    userno text,
    clientip text,
    logindate text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT LogNo, UserNo, ClientIP, LoginDate
	FROM Center_LoginLogs
	WHERE UserNo = center_getloginlogs.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
