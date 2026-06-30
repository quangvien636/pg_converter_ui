-- ─── FUNCTION: main_deletedashboard ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_deletedashboard(integer);
CREATE OR REPLACE FUNCTION public.main_deletedashboard(
    boardno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Main_DashBoards WHERE BoardNo = main_deletedashboard.boardno
	
	DELETE FROM Main_WidgetPlacements WHERE BoardNo = main_deletedashboard.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
