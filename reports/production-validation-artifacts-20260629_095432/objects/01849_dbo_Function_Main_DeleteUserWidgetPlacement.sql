-- ─── FUNCTION: main_deleteuserwidgetplacement ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_deleteuserwidgetplacement(integer);
CREATE OR REPLACE FUNCTION public.main_deleteuserwidgetplacement(
    placeno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Main_UserWidgetPlacements WHERE PlaceNo = main_deleteuserwidgetplacement.placeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
