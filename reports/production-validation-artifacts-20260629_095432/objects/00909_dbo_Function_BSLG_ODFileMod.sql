-- ─── FUNCTION: bslg_odfilemod ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_odfilemod(character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_odfilemod(
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
	 UPDATE BSLG_OrgLog
			 SET 
				att1 = bslg_odfilemod.att1
			 ,	att2 = bslg_odfilemod.att2
			 ,	att3 = bslg_odfilemod.att3
			 ,	att4 = bslg_odfilemod.att4
			 ,	att5 = bslg_odfilemod.att5
			WHERE DepartID=bslg_odfilemod.departid AND RegDate=bslg_odfilemod.date;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
