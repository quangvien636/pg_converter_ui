-- ─── FUNCTION: workingtime_getdevices ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getdevices();
CREATE OR REPLACE FUNCTION public.workingtime_getdevices(
) RETURNS TABLE(
    col1 text,
    userno text,
    deviceid text,
    notificationoptions text,
    timezoneoffset text,
    languagecode text,
    col7 text,
    col8 text,
    col9 text,
    col10 text,
    col11 text,
    col12 text,
    col13 text,
    col14 text,
    col15 text,
    col16 text
)
AS $function$
BEGIN





    RETURN QUERY
    SELECT   'A' AS Type, A.UserNo, A.DeviceID, A.NotificationOptions, A.TimezoneOffset, A.LanguageCode  
	        ,coalesce(g.id,0) Id
	 		--,COALESCE(G.TIMEIN,c_cin) TimeIn
			,c_cin TimeIn
			,c_out TimeOut
			--,COALESCE(G.TimeOut,c_out) TimeOut
		    ,COALESCE(G.SUN,0) SUN
		    ,COALESCE(G.MON,1) MON
		    ,COALESCE(G.TUE,1) TUE
		    ,COALESCE(G.WEN,1) WEN
		    ,COALESCE(G.THUR,1) THUR
		    ,COALESCE(G.FRI,1) FRI
		    ,COALESCE(G.SAT,0) SAT
    FROM WorkingTime_AndroidDevices  AS A  
    INNER JOIN Organization_Users  AS U ON U.UserNo = A.UserNo  
	left JOIN WorkingTime_SettingGroup G ON G.iD = U.GROUPID
    WHERE U.Enabled = TRUE  

     UNION ALL  

     RETURN QUERY
     SELECT 'I', I.UserNo, I.DeviceID, I.NotificationOptions, I.TimezoneOffset, I.LanguageCode  
			,coalesce(g.id,0) Id
	 		,c_cin TimeIn
			,c_out TimeOut
		    ,COALESCE(G.SUN,0) SUN
		    ,COALESCE(G.MON,1) MON
		    ,COALESCE(G.TUE,1) TUE
		    ,COALESCE(G.WEN,1) WEN
		    ,COALESCE(G.THUR,1) THUR
		    ,COALESCE(G.FRI,1) FRI
		    ,COALESCE(G.SAT,0) SAT
     FROM WorkingTime_IOSDevices  I
     INNER JOIN Organization_Users  AS U ON U.UserNo = I.UserNo  
	 left JOIN WorkingTime_SettingGroup G ON G.iD = U.GROUPID
     WHERE U.Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
