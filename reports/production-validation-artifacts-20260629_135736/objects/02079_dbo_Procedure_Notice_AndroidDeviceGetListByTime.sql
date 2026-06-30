-- ─── PROCEDURE→FUNCTION: notice_androiddevicegetlistbytime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_androiddevicegetlistbytime(character varying);
CREATE OR REPLACE FUNCTION public.notice_androiddevicegetlistbytime(
    IN p_unos character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

   IF p_unos = 'all' THEN
		RETURN QUERY
		select D.UserNo from Notice_AndroidDevices d
		WHERE D.IsAlarm = TRUE -- ALARM ON
		AND ((D.IsAlarmTime = TRUE AND StartTime <= p_StartTime AND D.EndTime >= p_StartTime  )OR D.IsAlarmTime = FALSE)
		END IF;
	ELSE
	  		RETURN QUERY
	  		select D.UserNo from Notice_AndroidDevices d
			INNER JOIN (SELECT VALUE FROM public."UF_TEXT_SPLIT"(p_unos,',')) U ON U.VALUE=d.UserNo
			WHERE D.IsAlarm = TRUE -- ALARM ON
			AND ((D.IsAlarmTime = TRUE AND StartTime <= p_StartTime AND D.EndTime >= p_StartTime  )OR D.IsAlarmTime = FALSE)
	  END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
