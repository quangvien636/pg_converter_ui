-- ─── FUNCTION: bslg_getdlog ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getdlog(character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getdlog(
    userid character varying,
    date character varying,
    plot character varying,
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
    att5 text,
    title text
)
AS $function$
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	if Orgcd is null
	 set Orgcd = ''

	IF Plot is null or Plot = ''
		IF Orgcd is null or Orgcd = ''
		BEGIN
			RETURN QUERY
			SELECT	UserID,RegDate,Content1, Content2, att1, att2, att3, att4, att5, Title
			FROM 	BSLG_Log 
			WHERE 	UserID=bslg_getdlog.userid AND RegDate = bslg_getdlog.date AND Plot = bslg_getdlog.plot
		END
		ELSE
		BEGIN
			RETURN QUERY
			SELECT	UserID,RegDate,Content1, Content2, att1, att2, att3, att4, att5, Title
			FROM 	BSLG_Log 
			WHERE 	UserID=bslg_getdlog.userid AND RegDate = bslg_getdlog.date AND OrgCd =bslg_getdlog.orgcd
		END
	ELSE 
		BEGIN
		RETURN QUERY
		SELECT	UserID,RegDate,Content1, Content2, att1, att2, att3, att4, att5, Title
		FROM 	BSLG_Log 
		WHERE 	UserID=bslg_getdlog.userid AND RegDate = bslg_getdlog.date AND Plot = bslg_getdlog.plot and OrgCd =bslg_getdlog.orgcd;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
