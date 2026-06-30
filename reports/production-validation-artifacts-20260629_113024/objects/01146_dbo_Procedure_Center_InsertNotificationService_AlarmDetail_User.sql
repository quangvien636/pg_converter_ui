-- ─── PROCEDURE→FUNCTION: center_insertnotificationservice_alarmdetail_user ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_insertnotificationservice_alarmdetail_user(bigint, bigint, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.center_insertnotificationservice_alarmdetail_user(
    IN notificationno bigint,
    IN notificationservice_alarmdetailno bigint,
    IN userno integer,
    IN message character varying,
    IN state boolean
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Center_NotificationService_AlarmDetail_User(NotificationNo,NotificationService_AlarmDetailNo,UserNo,Message,State)
	values(NotificationNo,NotificationService_AlarmDetailNo,UserNo,Message,State);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
