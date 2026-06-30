-- ─── PROCEDURE→FUNCTION: main_deleteuserwidgetplacement ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.main_deleteuserwidgetplacement(integer);
CREATE OR REPLACE FUNCTION public.main_deleteuserwidgetplacement(
    IN placeno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Main_UserWidgetPlacements WHERE PlaceNo = main_deleteuserwidgetplacement.placeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
