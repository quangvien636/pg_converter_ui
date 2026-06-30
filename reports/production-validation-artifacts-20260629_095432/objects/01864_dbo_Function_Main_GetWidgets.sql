-- ─── FUNCTION: main_getwidgets ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_getwidgets(integer);
CREATE OR REPLACE FUNCTION public.main_getwidgets(
    categoryno integer
) RETURNS TABLE(
    widgetno text,
    moduserno text,
    moddate text,
    name text,
    categoryno text,
    width text,
    height text,
    controlurl text,
    iscompany text,
    enabled text
)
AS $function$
BEGIN


	IF (CategoryNo = -1) BEGIN
	
		RETURN QUERY
		SELECT WidgetNo, ModUserNo, ModDate, Name, CategoryNo, Width, Height, ControlUrl, IsCompany, Enabled
		FROM Main_Widgets
	
	END
	
	ELSE BEGIN
		
		RETURN QUERY
		SELECT WidgetNo, ModUserNo, ModDate, Name, CategoryNo, Width, Height, ControlUrl, IsCompany, Enabled
		FROM Main_Widgets
		WHERE CategoryNo = main_getwidgets.categoryno
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
