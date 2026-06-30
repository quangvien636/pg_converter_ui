-- ─── FUNCTION: schedule_updatealarmsetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updatealarmsetting(integer, boolean, boolean, boolean, boolean, integer, boolean, boolean);
CREATE OR REPLACE FUNCTION public.schedule_updatealarmsetting(
    userno integer,
    isemail boolean,
    isalarmi boolean,
    ispc boolean,
    ismobile boolean,
    timealarm integer,
    isunuse boolean,
    p_wa boolean
) RETURNS void
AS $function$
BEGIN

	-- check exists
	if(exists(select 1 from ScheduleAlarmSetting ))
	begin
		-- update;
		update ScheduleAlarmSetting 
		set IsEmail = schedule_updatealarmsetting.isemail,IsAlarmi = schedule_updatealarmsetting.isalarmi,IsPC = schedule_updatealarmsetting.ispc, TimeAlarm = schedule_updatealarmsetting.timealarm , IsMobile = schedule_updatealarmsetting.ismobile, IsUnuse = schedule_updatealarmsetting.isunuse, ModDate = NOW(),ModUserNo = schedule_updatealarmsetting.userno
		,IsWebAlarm = schedule_updatealarmsetting.p_wa
		--where UserNo = UserNo
	end
	else
	begin
		-- INSERT INTO insert into ScheduleAlarmSetting(UserNo,IsEmail,IsAlarmi,IsPC,IsMobile, TimeAlarm, IsUnuse,RegUserNo,RegDate, IsWebAlarm)
		values (UserNo,IsEmail,IsAlarmi,IsPC,IsMobile,TimeAlarm,IsUnuse,UserNo, NOW(), p_wa)
	end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
