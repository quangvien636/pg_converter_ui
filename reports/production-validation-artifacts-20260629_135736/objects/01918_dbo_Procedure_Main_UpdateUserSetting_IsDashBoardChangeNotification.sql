-- ─── PROCEDURE→FUNCTION: main_updateusersetting_isdashboardchangenotification ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.main_updateusersetting_isdashboardchangenotification(integer, boolean);
CREATE OR REPLACE FUNCTION public.main_updateusersetting_isdashboardchangenotification(
    IN userno integer,
    IN isdashboardchangenotification boolean
) RETURNS void
AS $function$
BEGIN


	IF UserNo = -1 THEN

		UPDATE Main_UserSettings SET
			IsDashBoardChangeNotification = main_updateusersetting_isdashboardchangenotification.isdashboardchangenotification

	END IF;
	
	ELSE BEGIN
	
		UPDATE Main_UserSettings SET
			IsDashBoardChangeNotification = main_updateusersetting_isdashboardchangenotification.isdashboardchangenotification
		WHERE UserNo = main_updateusersetting_isdashboardchangenotification.userno
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
