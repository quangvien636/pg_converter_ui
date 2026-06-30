-- ─── FUNCTION: workingtime_getsettingbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getsettingbyuser(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getsettingbyuser(
    p_uno integer
) RETURNS TABLE(
    settingvalue text
)
AS $function$
BEGIN

		RETURN QUERY
		select * into #tam from Organization_Users WHERE UserNo = workingtime_getsettingbyuser.p_uno;
		   RETURN QUERY
		   SELECT
				U.UserNo, U.UserID, U.Name, U.Name_EN
				,COALESCE(G.ID,0) as ID
				,COALESCE(G.NAME,'') AS NameGroup
				, COALESCE(G.IsAddLunch,0) IsAddLunch
				, COALESCE(G.BIn1,'0000') BIn1
				, COALESCE(G.BIn2,'0000') BIn2
				, COALESCE(G.BOut1,'0000') BOut1
				, COALESCE(G.BOut2,'0000') BOut2
				, COALESCE(G.IsB1,0) IsB1
				, COALESCE(G.IsB2,0) IsB2
				,COALESCE(G.RegisteredId,'') RegisteredId
				, COALESCE(G.RegisteredDate,NOW())  RegisteredDate
				,COALESCE(G.TimeIn,ST1.SettingValue) TimeIn
				,COALESCE(G.TimeOut,ST2.SettingValue) TimeOut
				,COALESCE(G.LunchStart,'') LunchStart
				,COALESCE(G.LunchEnd,'') LunchEnd
				,COALESCE(G.Sun,WD.Sun) Sun
				,COALESCE(G.Mon,WD.Mon) Mon
				,COALESCE(G.Tue,WD.Tue) Tue
				,COALESCE(G.Wen,WD.Wen) Wen
				,COALESCE(G.Thur,WD.Thur) Thur
				,COALESCE(G.Fri,WD.Fri) Fri
				,COALESCE(G.Sat,WD.Sat) Sat
			FROM  #tam U  
			LEFT JOIN WorkingTime_SettingGroup G ON U.GroupId = G.ID
			LEFT JOIN (select * from WorkingTime_WeekDays WHERE ID = 1) WD ON 1 = 1
			LEFT JOIN (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 1) ST1 ON 1 = 1
			LEFT JOIN (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 2) ST2 ON 1 = 1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
