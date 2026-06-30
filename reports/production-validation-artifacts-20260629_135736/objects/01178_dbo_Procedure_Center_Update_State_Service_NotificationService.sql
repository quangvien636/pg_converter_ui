-- ─── PROCEDURE→FUNCTION: center_update_state_service_notificationservice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_update_state_service_notificationservice(bigint, boolean);
CREATE OR REPLACE FUNCTION public.center_update_state_service_notificationservice(
    IN notificationno bigint,
    IN state boolean
) RETURNS void
AS $function$
BEGIN


	update Center_NotificationService
	State := center_update_state_service_notificationservice.state,Execution = NOW();
	where NotificationNo = center_update_state_service_notificationservice.notificationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
