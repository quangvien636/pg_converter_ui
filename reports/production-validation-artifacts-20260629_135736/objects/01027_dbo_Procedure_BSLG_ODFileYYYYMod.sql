-- ─── PROCEDURE→FUNCTION: bslg_odfileyyyymod ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.bslg_odfileyyyymod(character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_odfileyyyymod(
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
	 UPDATE BSLG_OrgLogYYYY
			 att1 := bslg_odfileyyyymod.att1;
			 ,	att2 = bslg_odfileyyyymod.att2
			 ,	att3 = bslg_odfileyyyymod.att3
			 ,	att4 = bslg_odfileyyyymod.att4
			 ,	att5 = bslg_odfileyyyymod.att5
			WHERE DepartID=bslg_odfileyyyymod.departid AND RegDate=bslg_odfileyyyymod.date;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
