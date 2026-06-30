-- ─── PROCEDURE→FUNCTION: main_deletewidgetplacement ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.main_deletewidgetplacement(integer);
CREATE OR REPLACE FUNCTION public.main_deletewidgetplacement(
    IN placeno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Main_WidgetPlacements WHERE PlaceNo = main_deletewidgetplacement.placeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
