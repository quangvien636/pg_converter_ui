-- ─── FUNCTION: notice_deletenotificationservice ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_deletenotificationservice(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.notice_deletenotificationservice(
    companyno integer,
    projectcode character varying,
    connectionkey integer
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    notificationno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- declare

	-- get Notification ID
	RETURN QUERY
	select /* TOP 1 */ NotificationNo = NotificationNo from  Center_NotificationService where CompanyNo = notice_deletenotificationservice.companyno and ProjectCode = notice_deletenotificationservice.projectcode and Connectionkey = notice_deletenotificationservice.connectionkey 

	--DELETE FROM detail;
	DELETE FROM Center_NotificationService_AlarmDetail where NotificationNo = NotificationNo

	--DELETE FROM main;
	DELETE FROM Center_NotificationService where NotificationNo = NotificationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
