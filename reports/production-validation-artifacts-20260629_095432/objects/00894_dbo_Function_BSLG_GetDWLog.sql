-- ─── FUNCTION: bslg_getdwlog ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getdwlog(character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getdwlog(
    userid character varying,
    sdate character varying,
    edate character varying,
    searchtext character varying,
    orgcd character varying
) RETURNS TABLE(
    userid text,
    regdate text,
    content1 text,
    content2 text,
    att1 text,
    att2 text,
    att3 text,
    att4 text,
    att5 text
)
AS $function$
BEGIN
	RETURN QUERY
	SELECT UserID,RegDate,Content1, Content2, att1, att2, att3, att4, att5 
	FROM BSLG_Log WHERE Orgcd =bslg_getdwlog.orgcd 
	AND (Plot = '' or Plot is null)
	AND  Content1 ILIKE '%' || SearchText || '%'
	AND ( RegDate >= bslg_getdwlog.sdate AND RegDate <= bslg_getdwlog.edate) ORDER BY RegDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
