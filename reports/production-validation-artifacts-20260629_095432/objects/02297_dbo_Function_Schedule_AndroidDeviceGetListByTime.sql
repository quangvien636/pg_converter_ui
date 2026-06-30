-- ─── FUNCTION: schedule_androiddevicegetlistbytime ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_androiddevicegetlistbytime(character varying, time without time zone);
CREATE OR REPLACE FUNCTION public.schedule_androiddevicegetlistbytime(
    p_unos character varying,
    p_starttime time without time zone
) RETURNS TABLE(
    value text
)
AS $function$
BEGIN

   if p_unos = 'all'
	   begin
		RETURN QUERY
		select D.UserNo from Schedule_AndroidDevices d
		WHERE D.IsAlarm = TRUE -- ALARM ON
		AND ((D.IsAlarmTime = TRUE AND StartTime <= schedule_androiddevicegetlistbytime.p_starttime AND D.EndTime >= p_EndTime  )OR D.IsAlarmTime = FALSE)
		end
	else
	  begin
	  		RETURN QUERY
	  		select D.UserNo from Schedule_AndroidDevices d
			INNER JOIN (SELECT VALUE FROM public."UF_TEXT_SPLIT"(p_unos,',')) U ON U.VALUE=d.UserNo
			WHERE D.IsAlarm = TRUE -- ALARM ON
			AND ((D.IsAlarmTime = TRUE AND StartTime <= schedule_androiddevicegetlistbytime.p_starttime AND D.EndTime >= p_EndTime  )OR D.IsAlarmTime = FALSE)
	  end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
