-- ─── FUNCTION: bslg_getdeptdwlog ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getdeptdwlog(character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getdeptdwlog(
    userid character varying,
    sdate character varying,
    edate character varying,
    title character varying,
    content character varying,
    langindex character varying,
    orgcd character varying
) RETURNS TABLE(
    userid text,
    username text,
    regdate text,
    content1 text,
    content2 text,
    att1 text,
    att2 text,
    att3 text,
    att4 text,
    att5 text,
    title text
)
AS $function$
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	 if Orgcd is null
	   set Orgcd = ''
	
	 RETURN QUERY
	 SELECT UserID,public."CmonGetUserNm"(UserID,langindex) as UserName,RegDate,Content1, Content2, att1, att2, att3, att4, att5, Title  
	 FROM BSLG_Log   
	 WHERE UserID=bslg_getdeptdwlog.userid AND (RegDate >= bslg_getdeptdwlog.sdate AND RegDate <=  bslg_getdeptdwlog.edate )   
	 AND     Title ILIKE '%' || Title || '%'  
	 AND     Content1 ILIKE '%' || Content || '%'   and OrgCd = bslg_getdeptdwlog.orgcd
	 ORDER BY RegDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
