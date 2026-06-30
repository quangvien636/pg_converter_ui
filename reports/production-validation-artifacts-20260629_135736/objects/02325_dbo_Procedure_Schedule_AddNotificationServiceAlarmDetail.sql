-- ─── PROCEDURE→FUNCTION: schedule_addnotificationservicealarmdetail ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_addnotificationservicealarmdetail(integer, character varying, time without time zone, integer, character varying);
CREATE OR REPLACE FUNCTION public.schedule_addnotificationservicealarmdetail(
    IN p_nno integer,
    IN p_pcode character varying,
    IN p_stime time without time zone,
    IN p_time integer,
    IN p_title character varying
) RETURNS void
AS $function$
BEGIN

	INSERT INTO Center_NotificationService_AlarmDetail(NotificationNo,AlarmCode,AlarmStartTime,Alarm_Time,Title,Content_Json, RegDate)
	values (p_nNo, p_PCode, p_STime, p_Time,p_Title,p_json,NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
