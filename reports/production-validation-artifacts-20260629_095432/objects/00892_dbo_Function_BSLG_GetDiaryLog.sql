-- ─── FUNCTION: bslg_getdiarylog ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getdiarylog(character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getdiarylog(
    userid character varying,
    startdate character varying,
    enddate character varying,
    searchtext character varying
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
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	RETURN QUERY
	SELECT UserID,RegDate,Content1, Content2, att1, att2, att3, att4, att5 
	FROM BSLG_Log WHERE UserID=bslg_getdiarylog.userid 
	AND Plot = 'Diary'
	AND  Content1 ILIKE '%' || SearchText || '%'
	AND ( RegDate >= bslg_getdiarylog.startdate AND RegDate <= bslg_getdiarylog.enddate) ORDER BY RegDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
