-- ─── FUNCTION: workingtime_getuserssettings ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getuserssettings();
CREATE OR REPLACE FUNCTION public.workingtime_getuserssettings(
) RETURNS TABLE(
    userid text,
    userno text,
    col3 text,
    col4 text,
    col5 text,
    col6 text,
    col7 text,
    col8 text,
    col9 text
)
AS $function$
BEGIN


			RETURN QUERY
			SELECT 
				 U.UserID
				,U.UserNo
				,COALESCE(G.Sun,WD.Sun) Sun
				,COALESCE(G.Mon,WD.Mon) Mon
				,COALESCE(G.Tue,WD.Tue) Tue
				,COALESCE(G.Wen,WD.Wen) Wen
				,COALESCE(G.Thur,WD.Thur) Thur
				,COALESCE(G.Fri,WD.Fri) Fri
				,COALESCE(G.Sat,WD.Sat) Sat
			from Organization_Users U 
			LEFT JOIN WorkingTime_SettingGroup G ON U.GroupId = G.ID
			LEFT JOIN WorkingTime_WeekDays WD ON 1 = 1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
