-- ─── PROCEDURE→FUNCTION: bslg_readermod ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_readermod(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_readermod(
    IN regid character varying,
    IN readerid character varying,
    IN regdate character varying
) RETURNS SETOF record
AS $function$
DECLARE
    chk integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	SELECT  INTO  FROM BSLG_Reader 
	WHERE ReaderId = bslg_readermod.readerid
	AND   RegDate  = bslg_readermod.regdate
	
	IF Chk = 0 THEN;
		INSERT INTO BSLG_Reader (RegId, ReaderId, RegDate, ReadDate)
			VALUES (RegID, ReaderID, RegDate, NOW())
	END IF;
	ELSE;
		UPDATE BSLG_Reader 
			ReadDate := NOW();
		WHERE ReaderId = bslg_readermod.readerid
		AND   RegDate  = bslg_readermod.regdate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
