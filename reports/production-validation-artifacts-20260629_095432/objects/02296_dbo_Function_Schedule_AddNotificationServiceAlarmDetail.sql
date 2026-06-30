-- ─── FUNCTION: schedule_addnotificationservicealarmdetail ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_addnotificationservicealarmdetail(integer, character varying, time without time zone, integer, character varying);
CREATE OR REPLACE FUNCTION public.schedule_addnotificationservicealarmdetail(
    p_nno integer,
    p_pcode character varying,
    p_stime time without time zone,
    p_time integer,
    p_title character varying
) RETURNS void
AS $function$
BEGIN

	INSERT INTO Center_NotificationService_AlarmDetail(NotificationNo,AlarmCode,AlarmStartTime,Alarm_Time,Title,Content_Json, RegDate)
	values (p_nNo, p_PCode, p_STime, p_Time,p_Title,p_json,NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
