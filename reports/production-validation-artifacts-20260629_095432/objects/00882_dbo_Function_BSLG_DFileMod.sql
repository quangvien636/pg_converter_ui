-- ─── FUNCTION: bslg_dfilemod ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_dfilemod(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_dfilemod(
    att1 character varying,
    att2 character varying,
    att3 character varying,
    att4 character varying,
    att5 character varying,
    date character varying,
    userid character varying,
    flag character varying
) RETURNS void
AS $function$
BEGIN
	IF Flag = '1'
		BEGIN;
			 UPDATE BSLG_Log
			 SET 
				att1 = bslg_dfilemod.att1
			 ,	att2 = bslg_dfilemod.att2
			 ,	att3 = bslg_dfilemod.att3
			 ,	att4 = bslg_dfilemod.att4
			 ,	att5 = bslg_dfilemod.att5
			WHERE UserID=bslg_dfilemod.userid AND RegDate=bslg_dfilemod.date
		END
	ELSE
		BEGIN;
			 UPDATE BSLG_WLog
			 SET 
				att1 = bslg_dfilemod.att1
			 ,	att2 = bslg_dfilemod.att2
			 ,	att3 = bslg_dfilemod.att3
			 ,	att4 = bslg_dfilemod.att4
			 ,	att5 = bslg_dfilemod.att5
			WHERE UserID=bslg_dfilemod.userid AND RegDate=bslg_dfilemod.date;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
