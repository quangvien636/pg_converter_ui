-- ─── FUNCTION: main_deletewidgetplacement ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_deletewidgetplacement(integer);
CREATE OR REPLACE FUNCTION public.main_deletewidgetplacement(
    placeno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Main_WidgetPlacements WHERE PlaceNo = main_deletewidgetplacement.placeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
