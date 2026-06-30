-- ─── PROCEDURE→FUNCTION: workingtime_getuserssettings2 ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getuserssettings2();
CREATE OR REPLACE FUNCTION public.workingtime_getuserssettings2(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
				,Case when A.ContentAllow ILIKE '%false%' then 0 else 1 end Allow
			from Organization_Users U 
			LEFT JOIN WorkingTime_SettingGroup G ON U.GroupId = G.ID
			LEFT JOIN WorkingTime_AllowDevices A on A.UserNo = U.Userno
			LEFT JOIN WorkingTime_WeekDays WD ON 1 = 1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
