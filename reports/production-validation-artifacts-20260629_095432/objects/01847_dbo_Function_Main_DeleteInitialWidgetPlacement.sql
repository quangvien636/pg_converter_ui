-- ─── FUNCTION: main_deleteinitialwidgetplacement ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_deleteinitialwidgetplacement(integer);
CREATE OR REPLACE FUNCTION public.main_deleteinitialwidgetplacement(
    placeno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    widgetno integer;
BEGIN

	

	SELECT WidgetNo = WidgetNo
	FROM Main_InitialWidgetPlacements
	WHERE PlaceNo = main_deleteinitialwidgetplacement.placeno

	DELETE FROM Main_InitialWidgetPlacements WHERE PlaceNo = main_deleteinitialwidgetplacement.placeno
	
	DELETE FROM Main_WidgetPlacements WHERE WidgetNo = WidgetNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
