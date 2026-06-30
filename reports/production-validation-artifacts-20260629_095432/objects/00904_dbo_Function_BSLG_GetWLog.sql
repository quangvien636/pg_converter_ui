-- ─── FUNCTION: bslg_getwlog ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getwlog(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getwlog(
    userid character varying,
    startdate character varying,
    enddate character varying
) RETURNS TABLE(
    userid text,
    regdate text,
    content text,
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
	SELECT UserID,RegDate,Content, att1, att2, att3, att4, att5

	FROM BSLG_WLog 

	WHERE UserID=bslg_getwlog.userid AND ( RegDate >= bslg_getwlog.startdate AND RegDate <= bslg_getwlog.enddate ) 

	ORDER BY RegDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
