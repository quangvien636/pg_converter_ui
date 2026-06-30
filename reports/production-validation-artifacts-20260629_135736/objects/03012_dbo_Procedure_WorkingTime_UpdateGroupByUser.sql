-- ─── PROCEDURE→FUNCTION: workingtime_updategroupbyuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_updategroupbyuser(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_updategroupbyuser(
    IN p_uid integer,
    IN p_wid integer
) RETURNS void
AS $function$
BEGIN


	if(p_gid > 0)
		begin;
			UPDATE WorkingTime_Times 
			GroupId := g.id;
				,LunchStart = g.LunchStart
				,LunchEnd = g.LunchEnd
				,StarWorking =g.TimeIn
				,EndWorking = g.TimeOut
				,IsAddLunch = g.IsAddLunch
				, BIn1 = g.BIn1
				, BOut1= g.BOut1
				, BIn2 = g.BIn2
				, BOut2= g.BOut2
				, IsB1 = g.IsB1
				, IsB2 = g.IsB2
			FROM 
			(
				select g.*
				from WorkingTime_SettingGroup g
				where g.id = p_gid
			) g
			WHERE WorkingNo = workingtime_updategroupbyuser.p_wid
		END;
	ELSE;
		 	UPDATE WorkingTime_Times 
			GroupId := 0,;
				LunchStart = (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 4),
				LunchEnd = (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 5),
				StarWorking =(SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 1),
				EndWorking = (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 2),
				IsAddLunch = (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 6)
				, BIn1 =  (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 10)
				, BOut1=  (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 11)
				, BIn2 =  (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 12)
				, BOut2=  (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 13)
				, IsB1 =  (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 14)
				, IsB2 =  (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 15)
			WHERE WorkingNo = workingtime_updategroupbyuser.p_wid
		END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
