-- ─── FUNCTION: bslg_odfileyyyymod ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_odfileyyyymod(character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_odfileyyyymod(
    att1 character varying,
    att2 character varying,
    att3 character varying,
    att4 character varying,
    att5 character varying,
    date character varying,
    departid character varying
) RETURNS void
AS $function$
BEGIN
	 UPDATE BSLG_OrgLogYYYY
			 SET 
				att1 = bslg_odfileyyyymod.att1
			 ,	att2 = bslg_odfileyyyymod.att2
			 ,	att3 = bslg_odfileyyyymod.att3
			 ,	att4 = bslg_odfileyyyymod.att4
			 ,	att5 = bslg_odfileyyyymod.att5
			WHERE DepartID=bslg_odfileyyyymod.departid AND RegDate=bslg_odfileyyyymod.date;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
