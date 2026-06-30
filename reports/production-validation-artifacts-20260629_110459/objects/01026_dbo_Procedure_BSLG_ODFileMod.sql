-- ─── PROCEDURE→FUNCTION: bslg_odfilemod ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.bslg_odfilemod(character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_odfilemod(
    IN att1 character varying,
    IN att2 character varying,
    IN att3 character varying,
    IN att4 character varying,
    IN att5 character varying,
    IN date character varying,
    IN departid character varying
) RETURNS void
AS $function$
BEGIN
	 UPDATE BSLG_OrgLog
			 att1 := bslg_odfilemod.att1;
			 ,	att2 = bslg_odfilemod.att2
			 ,	att3 = bslg_odfilemod.att3
			 ,	att4 = bslg_odfilemod.att4
			 ,	att5 = bslg_odfilemod.att5
			WHERE DepartID=bslg_odfilemod.departid AND RegDate=bslg_odfilemod.date;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
