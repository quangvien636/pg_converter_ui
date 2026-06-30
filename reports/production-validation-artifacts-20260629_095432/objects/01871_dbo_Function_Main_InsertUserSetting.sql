-- ─── FUNCTION: main_insertusersetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_insertusersetting(integer, boolean, character varying, boolean);
CREATE OR REPLACE FUNCTION public.main_insertusersetting(
    userno integer,
    usecustomdashboard boolean,
    order character varying,
    isdashboardchangenotification boolean
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Main_UserSettings (UserNo, UseCustomDashBoard, DashBoardDisplayOrder, IsDashBoardChangeNotification, FirstProjectCode)
	VALUES (UserNo, UseCustomDashBoard, Order, IsDashBoardChangeNotification, FirstProjectCode);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
