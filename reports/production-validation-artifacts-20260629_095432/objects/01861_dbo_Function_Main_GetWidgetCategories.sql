-- ─── FUNCTION: main_getwidgetcategories ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_getwidgetcategories(boolean);
CREATE OR REPLACE FUNCTION public.main_getwidgetcategories(
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
		FROM Main_WidgetCategories
		ORDER BY Name ASC
	
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT CategoryNo, ModUserNo, ModDate, ParentNo, Name, Enabled
		FROM Main_WidgetCategories
		WHERE Enabled = TRUE
		ORDER BY Name ASC
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
