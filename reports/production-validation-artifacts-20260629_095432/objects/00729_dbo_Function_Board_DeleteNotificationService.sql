-- ─── FUNCTION: board_deletenotificationservice ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_deletenotificationservice(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.board_deletenotificationservice(
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
	select /* TOP 1 */ NotificationNo = NotificationNo from  Center_NotificationService where CompanyNo = board_deletenotificationservice.companyno and ProjectCode = board_deletenotificationservice.projectcode and Connectionkey = board_deletenotificationservice.connectionkey 

	--DELETE FROM detail;
	DELETE FROM Center_NotificationService_AlarmDetail where NotificationNo = NotificationNo

	--DELETE FROM main;
	DELETE FROM Center_NotificationService where NotificationNo = NotificationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
