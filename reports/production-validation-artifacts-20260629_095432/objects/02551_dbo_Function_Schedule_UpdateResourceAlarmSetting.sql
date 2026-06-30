-- ─── FUNCTION: schedule_updateresourcealarmsetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateresourcealarmsetting(integer, boolean, boolean, boolean, boolean, integer, boolean, boolean);
CREATE OR REPLACE FUNCTION public.schedule_updateresourcealarmsetting(
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
	if(exists(select 1 from ScheduleResourceAlarmSetting ))
	begin
		-- update;
		update ScheduleResourceAlarmSetting 
		set IsEmail = schedule_updateresourcealarmsetting.isemail,IsAlarmi = schedule_updateresourcealarmsetting.isalarmi,IsPC = schedule_updateresourcealarmsetting.ispc, TimeAlarm = schedule_updateresourcealarmsetting.timealarm , IsMobile = schedule_updateresourcealarmsetting.ismobile, IsUnuse = schedule_updateresourcealarmsetting.isunuse, ModDate = NOW(),ModUserNo = schedule_updateresourcealarmsetting.userno
		,IsWebAlarm = schedule_updateresourcealarmsetting.p_wa
		--where UserNo = UserNo
	end
	else
	begin
		-- INSERT INTO insert into ScheduleResourceAlarmSetting(UserNo,IsEmail,IsAlarmi,IsPC,IsMobile, TimeAlarm, IsUnuse,RegUserNo,RegDate,IsWebAlarm)
		values (UserNo,IsEmail,IsAlarmi,IsPC,IsMobile,TimeAlarm,IsUnuse,UserNo, NOW(),p_wa)
	end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
