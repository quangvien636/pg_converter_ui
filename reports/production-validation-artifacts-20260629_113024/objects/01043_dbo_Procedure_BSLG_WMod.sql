-- ─── PROCEDURE→FUNCTION: bslg_wmod ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_wmod(character varying, character varying, text);
CREATE OR REPLACE FUNCTION public.bslg_wmod(
    IN userid character varying,
    IN date character varying,
    IN content text
) RETURNS SETOF record
AS $function$
DECLARE
    chk character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	

	SELECT UserID INTO chk FROM BSLG_WLog WHERE UserID = bslg_wmod.userid AND RegDate=bslg_wmod.date

	IF UserID = Chk THEN;
			UPDATE BSLG_WLog SET Content=bslg_wmod.content 
			WHERE  UserID = bslg_wmod.userid AND RegDate=bslg_wmod.date
		END IF;
	ELSE;
			INSERT INTO BSLG_WLog(UserID, RegDate, Content)
			VALUES(UserID, Date, Content);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
