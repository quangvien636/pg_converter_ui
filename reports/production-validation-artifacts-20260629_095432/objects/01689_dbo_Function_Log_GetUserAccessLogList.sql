-- ─── FUNCTION: log_getuseraccessloglist ───────────────────────────────
DROP FUNCTION IF EXISTS public.log_getuseraccessloglist();
CREATE OR REPLACE FUNCTION public.log_getuseraccessloglist(
) RETURNS TABLE(
    logno text,
    clientip text,
    userno text,
    accdate text,
    accmodule text,
    username text
)
AS $function$
BEGIN



    RETURN QUERY
    SELECT LogNo, ClientIP, UserNo, AccDate, AccModule, UserName 
    FROM AccessLog WHERE UserNo = UserNo
    ORDER BY LogNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
