-- ─── FUNCTION: workingtime_getusersbydepartandgroup2 ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getusersbydepartandgroup2(timestamp without time zone, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_getusersbydepartandgroup2(
    p_date timestamp without time zone,
    p_departno integer,
    p_groupno integer,
    p_uid character varying DEFAULT '',
    p_uname character varying DEFAULT '',
    p_unameen character varying DEFAULT ''
) RETURNS TABLE(
    departno text
)
AS $function$
BEGIN

		   RETURN QUERY
		   SELECT
				B.UserNo, U.UserID, U.Name, U.Name_EN
				,D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN
				,P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN
				,U.BirthDate
				,G.ID
				,COALESCE(G.NAME,'') AS NameGroup
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
			FROM (select max(BelongNo) BelongNo,max(PositionNo) PositionNo, max(DepartNo) DepartNo,max(DutyNo) DutyNo, UserNo from  Organization_BelongToDepartment group by UserNo) B
			INNER JOIN Organization_Users U  ON U.UserNo = B.UserNo  AND U.IsVirtual = FALSE
			INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
			INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
			JOIN (SELECT u1.UserNo FROM Organization_Users U1 LEFT JOIN WorkingTime_AllowDevices A ON U1.userno = a.userno	where COALESCE(ContentAllow, 'true') ILIKE '%true%') AL ON U.UserNo = AL.UserNo
			LEFT JOIN Organization_Duties DT  ON DT.DutyNo = B.DutyNo
			LEFT JOIN WorkingTime_SettingGroup G ON U.GroupId = G.ID
			LEFT JOIN (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 1) ST1 ON 1 = 1
			LEFT JOIN (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 2) ST2 ON 1 = 1
			LEFT JOIN (select * from WorkingTime_WeekDays WHERE ID = 1) WD ON 1 = 1
			LEFT JOIN Organization_SortingEachDepartment S ON S.UserNo = U.UserNo and S.DepartNo = workingtime_getusersbydepartandgroup2.p_departno
			WHERE (p_DepartNo = 0 OR B.DepartNo IN (SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(p_DepartNo, 0)))
			AND ( (p_GroupNo = 0 OR G.ID = workingtime_getusersbydepartandgroup2.p_groupno) OR (p_GroupNo !=  0 AND G.ID = workingtime_getusersbydepartandgroup2.p_groupno))
			AND (p_Uid = '' OR LOWER(U.UserID) ILIKE '%' || p_Uid || '%')
			AND (p_UName = '' OR LOWER(U.Name) ILIKE '%' || p_UName || '%')
			AND (p_UNameEn = '' OR LOWER(U.Name_EN) ILIKE '%' || p_UNameEn || '%')
			AND (U.Enabled = TRUE OR  U.ModDate >= workingtime_getusersbydepartandgroup2.p_date)
			ORDER BY COALESCE(S.SortNo,99999) ASC, P.SortNo ASC, DT.SortNo ASC, U.Name ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
