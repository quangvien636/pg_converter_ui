-- ─── FUNCTION: bslg_getorglogyyyy ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getorglogyyyy(character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getorglogyyyy(
    departid character varying,
    date character varying
) RETURNS TABLE(
    departid text,
    regdate text,
    slog text,
    elog text,
    userno text,
    att1 text,
    att2 text,
    att3 text,
    att4 text,
    att5 text
)
AS $function$
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	RETURN QUERY
	SELECT DepartID, RegDate, SLog, ELog,UserNo, att1, att2, att3, att4, att5 FROM 
	BSLG_OrgLogYYYY WHERE RegDate=bslg_getorglogyyyy.date AND DepartID=bslg_getorglogyyyy.departid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
