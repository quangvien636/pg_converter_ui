-- ─── PROCEDURE→FUNCTION: main_deletedashboard ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.main_deletedashboard(integer);
CREATE OR REPLACE FUNCTION public.main_deletedashboard(
    IN boardno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Main_DashBoards WHERE BoardNo = main_deletedashboard.boardno
	
	DELETE FROM Main_WidgetPlacements WHERE BoardNo = main_deletedashboard.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
