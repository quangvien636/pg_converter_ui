-- ─── PROCEDURE→FUNCTION: bslg_cmtmod ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_cmtmod(character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_cmtmod(
    IN userid character varying,
    IN targetid character varying,
    IN regdate character varying,
    IN content character varying,
    IN orgcd character varying
) RETURNS SETOF record
AS $function$
DECLARE
    chk character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
   IF orgcd is null THEN
    orgcd := '';;
	INSERT INTO BSLG_Comment

	VALUES(Content, TargetID, UserID, RegDate, Flag, convert(char(10), NOW(), 120),orgcd)

	/*

	SELECT  INTO  FROM 	BSLG_Comment

	WHERE  TargetID = bslg_cmtmod.targetid AND WriterID = bslg_cmtmod.userid AND RegDate=bslg_cmtmod.regdate AND ID > 0

	IF Chk > 0 THEN;
			UPDATE BSLG_Comment

			Content := bslg_cmtmod.content;
			WHERE  TargetID = bslg_cmtmod.targetid AND WriterID = bslg_cmtmod.userid AND RegDate=bslg_cmtmod.regdate AND ID > 0
		END IF;
	ELSE;
			INSERT INTO BSLG_Comment

			VALUES(Content, TargetID, UserID, RegDate, Flag, convert(char(10), NOW(), 120))
		END IF;

	*/
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
