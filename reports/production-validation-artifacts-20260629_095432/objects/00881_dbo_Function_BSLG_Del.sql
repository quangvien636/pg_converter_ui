-- ─── FUNCTION: bslg_del ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_del(character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_del(
    userid character varying,
    date character varying,
    plot character varying,
    orgcd character varying
) RETURNS void
AS $function$
BEGIN
	DELETE FROM BSLG_Log 
	WHERE UserID = bslg_del.userid AND RegDate=bslg_del.date AND Plot = bslg_del.plot;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
