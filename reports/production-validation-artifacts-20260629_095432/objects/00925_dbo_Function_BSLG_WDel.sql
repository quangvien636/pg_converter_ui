-- ─── FUNCTION: bslg_wdel ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_wdel(character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_wdel(
    userid character varying,
    date character varying
) RETURNS void
AS $function$
BEGIN
	DELETE FROM BSLG_WLog WHERE UserID = bslg_wdel.userid AND RegDate=bslg_wdel.date;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
