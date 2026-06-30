-- ─── FUNCTION: notice_iosdevicegetlistbytime ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_iosdevicegetlistbytime(character varying);
CREATE OR REPLACE FUNCTION public.notice_iosdevicegetlistbytime(
    p_unos character varying
) RETURNS TABLE(
    value text
)
AS $function$
BEGIN

   if p_unos = 'all'
	   begin
		RETURN QUERY
		select D.UserNo from Notice_IOSDevices d
		WHERE D.IsAlarm = TRUE -- ALARM ON
		AND ((D.IsAlarmTime = TRUE AND StartTime <= p_StartTime AND D.EndTime >= p_StartTime  )OR D.IsAlarmTime = FALSE)
	  end
	else
	  begin
	   	RETURN QUERY
	   	select D.UserNo from Notice_IOSDevices d
		INNER JOIN (SELECT VALUE FROM public."UF_TEXT_SPLIT"(p_unos,',')) U ON U.VALUE=d.UserNo
		WHERE D.IsAlarm = TRUE -- ALARM ON
		AND ((D.IsAlarmTime = TRUE AND StartTime <= p_StartTime AND D.EndTime >= p_StartTime  )OR D.IsAlarmTime = FALSE)
	  end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
