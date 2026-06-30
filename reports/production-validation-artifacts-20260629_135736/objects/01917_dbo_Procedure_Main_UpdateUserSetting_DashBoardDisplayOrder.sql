-- ─── PROCEDURE→FUNCTION: main_updateusersetting_dashboarddisplayorder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.main_updateusersetting_dashboarddisplayorder(integer);
CREATE OR REPLACE FUNCTION public.main_updateusersetting_dashboarddisplayorder(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Main_UserSettings SET
		DashBoardDisplayOrder = Order
	WHERE UserNo = main_updateusersetting_dashboarddisplayorder.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
