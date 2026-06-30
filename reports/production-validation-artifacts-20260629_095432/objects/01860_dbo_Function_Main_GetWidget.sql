-- ─── FUNCTION: main_getwidget ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_getwidget(integer);
CREATE OR REPLACE FUNCTION public.main_getwidget(
    widgetno integer
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


	RETURN QUERY
	SELECT WidgetNo, ModUserNo, ModDate, Name, CategoryNo, Width, Height, ControlUrl, IsCompany, Enabled
	FROM Main_Widgets
	WHERE WidgetNo = main_getwidget.widgetno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
