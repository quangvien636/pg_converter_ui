-- ─── PROCEDURE→FUNCTION: center_deletenotificationservice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_deletenotificationservice(bigint);
CREATE OR REPLACE FUNCTION public.center_deletenotificationservice(
    IN notificationno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_NotificationService where NotificationNo = center_deletenotificationservice.notificationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
