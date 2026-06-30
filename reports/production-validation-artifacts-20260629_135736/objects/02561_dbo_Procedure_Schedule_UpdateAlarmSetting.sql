-- ─── PROCEDURE→FUNCTION: schedule_updatealarmsetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updatealarmsetting(integer, boolean, boolean, boolean, boolean, integer, boolean, boolean);
CREATE OR REPLACE FUNCTION public.schedule_updatealarmsetting(
    IN userno integer,
    IN isemail boolean,
    IN isalarmi boolean,
    IN ispc boolean,
    IN ismobile boolean,
    IN timealarm integer,
    IN isunuse boolean,
    IN p_wa boolean
) RETURNS void
AS $function$
BEGIN

	-- check exists
	if(exists(select 1 from ScheduleAlarmSetting ))
	begin
		-- update;
		update ScheduleAlarmSetting 
		IsEmail := schedule_updatealarmsetting.isemail,IsAlarmi = schedule_updatealarmsetting.isalarmi,IsPC = schedule_updatealarmsetting.ispc, TimeAlarm = schedule_updatealarmsetting.timealarm , IsMobile = schedule_updatealarmsetting.ismobile, IsUnuse = schedule_updatealarmsetting.isunuse, ModDate = NOW(),ModUserNo = schedule_updatealarmsetting.userno;
		,IsWebAlarm = schedule_updatealarmsetting.p_wa
		--where UserNo = UserNo
	END;
	ELSE
		-- INSERT INTO insert into ScheduleAlarmSetting(UserNo,IsEmail,IsAlarmi,IsPC,IsMobile, TimeAlarm, IsUnuse,RegUserNo,RegDate, IsWebAlarm)
		values (UserNo,IsEmail,IsAlarmi,IsPC,IsMobile,TimeAlarm,IsUnuse,UserNo, NOW(), p_wa)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
