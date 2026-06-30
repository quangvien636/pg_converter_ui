-- ─── PROCEDURE→FUNCTION: edms_insertdocumenttag ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edms_insertdocumenttag(integer, bigint, integer);
CREATE OR REPLACE FUNCTION public.edms_insertdocumenttag(
    IN userno integer,
    IN documentno bigint,
    IN tagno integer
) RETURNS SETOF record
AS $function$
DECLARE
    _tagno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF TagNo = 0 THEN
	
		INSERT INTO EDMS_Tags (RegUserNo, RegDate, Name)
		VALUES (UserNo, NOW(), TagName)
		

		_TagNo := lastval();;
		INSERT INTO EDMS_DocumentTags (DocumentNo, TagNo)
		VALUES (DocumentNo, _TagNo)
		
		RETURN QUERY
		SELECT _TagNo
	
	END IF;

	ELSE BEGIN
	
		INSERT INTO EDMS_DocumentTags (DocumentNo, TagNo)
		VALUES (DocumentNo, TagNo)
		
		RETURN QUERY
		SELECT TagNo
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
