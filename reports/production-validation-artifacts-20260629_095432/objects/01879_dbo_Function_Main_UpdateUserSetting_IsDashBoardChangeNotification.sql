-- ─── FUNCTION: main_updateusersetting_isdashboardchangenotification ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_updateusersetting_isdashboardchangenotification(integer, boolean);
CREATE OR REPLACE FUNCTION public.main_updateusersetting_isdashboardchangenotification(
    userno integer,
    isdashboardchangenotification boolean
) RETURNS void
AS $function$
BEGIN


	IF UserNo = -1 BEGIN

		UPDATE Main_UserSettings SET
			IsDashBoardChangeNotification = main_updateusersetting_isdashboardchangenotification.isdashboardchangenotification

	END
	
	ELSE BEGIN
	
		UPDATE Main_UserSettings SET
			IsDashBoardChangeNotification = main_updateusersetting_isdashboardchangenotification.isdashboardchangenotification
		WHERE UserNo = main_updateusersetting_isdashboardchangenotification.userno
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
