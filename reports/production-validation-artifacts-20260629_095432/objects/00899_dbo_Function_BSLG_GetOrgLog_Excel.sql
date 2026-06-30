-- ─── FUNCTION: bslg_getorglog_excel ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getorglog_excel(character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getorglog_excel(
    departid character varying,
    date character varying
) RETURNS TABLE(
    departid text,
    regdate text,
    slog text,
    elog text,
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
	SELECT 
	DepartID, 
	RegDate, 
	REPLACE(REPLACE(Convert(text,SLog),char(13),'<br>'),CHAR(10),'') as SLog, 
	REPLACE(REPLACE(Convert(text,ELog),char(13),'<br>'),CHAR(10),'')  as ELog, 
	att1, 
	att2, 
	att3, 
	att4, 
	att5 
	FROM BSLG_OrgLog 
	WHERE RegDate=bslg_getorglog_excel.date AND DepartID=bslg_getorglog_excel.departid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
