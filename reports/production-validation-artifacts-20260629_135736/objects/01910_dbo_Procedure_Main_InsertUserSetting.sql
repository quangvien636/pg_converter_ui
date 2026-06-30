-- ─── PROCEDURE→FUNCTION: main_insertusersetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.main_insertusersetting(integer, boolean, character varying, boolean);
CREATE OR REPLACE FUNCTION public.main_insertusersetting(
    IN userno integer,
    IN usecustomdashboard boolean,
    IN order character varying,
    IN isdashboardchangenotification boolean
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Main_UserSettings (UserNo, UseCustomDashBoard, DashBoardDisplayOrder, IsDashBoardChangeNotification, FirstProjectCode)
	VALUES (UserNo, UseCustomDashBoard, Order, IsDashBoardChangeNotification, FirstProjectCode);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
