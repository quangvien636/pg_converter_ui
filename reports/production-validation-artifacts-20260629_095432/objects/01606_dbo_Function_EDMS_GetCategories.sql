-- ─── FUNCTION: edms_getcategories ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getcategories(boolean);
CREATE OR REPLACE FUNCTION public.edms_getcategories(
    alsodisabled boolean
) RETURNS TABLE(
    categoryno text,
    moduserno text,
    moddate text,
    parentno text,
    name text,
    enabled text
)
AS $function$
BEGIN


	IF AlsoDisabled = 1 BEGIN

		RETURN QUERY
		SELECT CategoryNo, ModUserNo, ModDate, ParentNo, Name, Enabled
		FROM EDMS_Categories
		ORDER BY Name ASC
	
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT CategoryNo, ModUserNo, ModDate, ParentNo, Name, Enabled
		FROM EDMS_Categories
		WHERE Enabled = TRUE
		ORDER BY Name ASC
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
