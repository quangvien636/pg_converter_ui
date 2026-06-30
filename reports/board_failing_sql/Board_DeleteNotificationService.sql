-- ─── PROCEDURE→FUNCTION: board_deletenotificationservice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_deletenotificationservice(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.board_deletenotificationservice(
    IN companyno integer,
    IN projectcode character varying,
    IN connectionkey integer
) RETURNS void
AS $function$
DECLARE
    notificationno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- declare

	-- get Notification ID
	SELECT NotificationNo INTO notificationno from  Center_NotificationService where CompanyNo = board_deletenotificationservice.companyno and ProjectCode = board_deletenotificationservice.projectcode and Connectionkey = board_deletenotificationservice.connectionkey 

	--DELETE FROM detail;
	DELETE FROM Center_NotificationService_AlarmDetail where NotificationNo = NotificationNo

	--DELETE FROM main;
	DELETE FROM Center_NotificationService where NotificationNo = NotificationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.