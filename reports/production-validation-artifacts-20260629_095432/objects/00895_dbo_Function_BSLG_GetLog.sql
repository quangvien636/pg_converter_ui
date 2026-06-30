-- ─── FUNCTION: bslg_getlog ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getlog(character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getlog(
    userid character varying,
    startdate character varying,
    enddate character varying,
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
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF Orgcd is null or Orgcd = '' or Orgcd = '*'
	BEGIN
		RETURN QUERY
		SELECT UserID,RegDate,Content1, Content2, att1, att2, att3, att4, att5 
		FROM BSLG_Log WHERE UserID=bslg_getlog.userid 
		AND (Plot = '' or Plot is null)
		AND  Content1 ILIKE '%' || SearchText || '%'
		AND ( RegDate >= bslg_getlog.startdate AND RegDate <= bslg_getlog.enddate) 
		--ANd Orgcd = Orgcd
		ORDER BY RegDate 
	END
	ELSE
	BEGIN
		RETURN QUERY
		SELECT UserID,RegDate,Content1, Content2, att1, att2, att3, att4, att5 
		FROM BSLG_Log WHERE UserID=bslg_getlog.userid 
		AND (Plot = '' or Plot is null)
		AND  Content1 ILIKE '%' || SearchText || '%'
		AND ( RegDate >= bslg_getlog.startdate AND RegDate <= bslg_getlog.enddate) 
		ANd Orgcd = bslg_getlog.orgcd
		ORDER BY RegDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
