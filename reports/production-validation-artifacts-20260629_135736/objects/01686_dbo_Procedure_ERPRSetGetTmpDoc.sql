-- ─── PROCEDURE→FUNCTION: erprsetgettmpdoc ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.erprsetgettmpdoc(character varying, integer, character varying, text, integer);
CREATE OR REPLACE FUNCTION public.erprsetgettmpdoc(
    IN mode character varying,
    INOUT erpseq integer DEFAULT NULL,
    INOUT erpkeyxml character varying DEFAULT NULL,
    IN erpdoc text DEFAULT NULL,
    IN id integer DEFAULT NULL
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
IF Mode='i' THEN;
	Insert into public."ERPRBrdgEAPP" (ErpKeyXml,ErpDoc) Values(ErpKeyXml,ErpDoc)
	ErpSeq := @Identity;
END IF;
ELSIF Mode='s' THEN
	RETURN QUERY
	Select ErpKeyXml,ErpDoc From ERPRBrdgEAPP Where ErpSeq=erprsetgettmpdoc.erpseq
END IF;
ELSIF Mode='p' THEN
	ErpKeyXml := (Select ErpKey From eappdocument Where ID=erprsetgettmpdoc.id);
END IF;
ELSIF Mode='k' THEN
	SELECT ErpKeyXml INTO erpkeyxml From ERPRBrdgEAPP Where ErpSeq=erprsetgettmpdoc.erpseq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
