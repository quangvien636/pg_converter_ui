-- ─── PROCEDURE→FUNCTION: bslg_dfilemod ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.bslg_dfilemod(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_dfilemod(
    IN att1 character varying,
    IN att2 character varying,
    IN att3 character varying,
    IN att4 character varying,
    IN att5 character varying,
    IN date character varying,
    IN userid character varying,
    IN flag character varying
) RETURNS void
AS $function$
BEGIN
	IF Flag = '1' THEN;
			 UPDATE BSLG_Log
			 att1 := bslg_dfilemod.att1;
			 ,	att2 = bslg_dfilemod.att2
			 ,	att3 = bslg_dfilemod.att3
			 ,	att4 = bslg_dfilemod.att4
			 ,	att5 = bslg_dfilemod.att5
			WHERE UserID=bslg_dfilemod.userid AND RegDate=bslg_dfilemod.date
		END IF;
	ELSE;
			 UPDATE BSLG_WLog
			 att1 := bslg_dfilemod.att1;
			 ,	att2 = bslg_dfilemod.att2
			 ,	att3 = bslg_dfilemod.att3
			 ,	att4 = bslg_dfilemod.att4
			 ,	att5 = bslg_dfilemod.att5
			WHERE UserID=bslg_dfilemod.userid AND RegDate=bslg_dfilemod.date;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
