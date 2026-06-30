-- ─── FUNCTION: eappprogressopionupdate ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappprogressopionupdate(integer, character varying);
CREATE OR REPLACE FUNCTION public.eappprogressopionupdate(
    progid integer,
    opionins character varying DEFAULT NULL
) RETURNS void
AS $function$
DECLARE
    ptrval binary(16);
BEGIN

	   FROM EAPPPROGRESS
		WHERE ID  = eappprogressopionupdate.progid
	  RAISE NOTICE '%', PTRVAL
	UPDATETEXT EAPPPROGRESS.OPINION PTRVAL  0 0 OPIONINS;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
