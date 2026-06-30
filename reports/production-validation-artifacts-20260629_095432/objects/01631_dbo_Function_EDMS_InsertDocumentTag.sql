-- ─── FUNCTION: edms_insertdocumenttag ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_insertdocumenttag(integer, bigint, integer);
CREATE OR REPLACE FUNCTION public.edms_insertdocumenttag(
    userno integer,
    documentno bigint,
    tagno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    _tagno integer;
BEGIN


	IF (TagNo = 0) BEGIN
	
		INSERT INTO EDMS_Tags (RegUserNo, RegDate, Name)
		VALUES (UserNo, NOW(), TagName)
		

		SET _TagNo = lastval()
		
		INSERT INTO EDMS_DocumentTags (DocumentNo, TagNo)
		VALUES (DocumentNo, _TagNo)
		
		RETURN QUERY
		SELECT _TagNo
	
	END

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
