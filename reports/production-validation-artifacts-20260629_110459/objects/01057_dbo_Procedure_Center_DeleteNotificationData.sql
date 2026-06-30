-- ─── PROCEDURE→FUNCTION: center_deletenotificationdata ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_deletenotificationdata(bigint);
CREATE OR REPLACE FUNCTION public.center_deletenotificationdata(
    IN notificationno bigint
) RETURNS void
AS $function$
BEGIN

	
	DELETE FROM Center_NotificationData WHERE NotificationNo = center_deletenotificationdata.notificationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
