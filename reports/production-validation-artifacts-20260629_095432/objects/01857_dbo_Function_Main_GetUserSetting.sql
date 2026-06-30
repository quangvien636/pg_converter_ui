-- ─── FUNCTION: main_getusersetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_getusersetting(integer);
CREATE OR REPLACE FUNCTION public.main_getusersetting(
    userno integer
) RETURNS TABLE(
    usecustomdashboard text,
    dashboarddisplayorder text,
    isdashboardchangenotification text,
    firstprojectcode text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT UseCustomDashBoard, DashBoardDisplayOrder, IsDashBoardChangeNotification, FirstProjectCode
	FROM Main_UserSettings
	WHERE UserNo = main_getusersetting.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
