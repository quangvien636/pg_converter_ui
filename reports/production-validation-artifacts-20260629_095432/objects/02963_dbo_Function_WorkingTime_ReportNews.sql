-- ─── FUNCTION: workingtime_reportnews ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_reportnews(character varying, character varying, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_reportnews(
    p_from character varying,
    p_to character varying,
    p_departno integer DEFAULT 0,
    p_groupno integer DEFAULT 0,
    p_uid character varying DEFAULT '',
    p_uname character varying DEFAULT '',
    p_unameen character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN



			SELECT 
				 S.SortNo, P.SortNo PSortNo, DT.SortNo DTSortNo, D.SortNo AS DSortNo
				, B.UserNo, U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN, U.MailAddress, U.CellPhone, U.CompanyPhone, U.UserPhoto, U.Photo, U.Enabled
				, D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN
				,P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN, P.SortNo AS PositionSortNo
				,U.Name_CH,U.Name_JP,U.Name_VN
				,D.Name_CH AS DepartName_CH,D.Name_JP AS DepartName_JP,D.Name_VN AS DepartName_VN
				,P.Name_CH AS PositionName_CH,P.Name_JP AS PositionName_JP,P.Name_VN AS PositionName_VN
				,COALESCE(G.TimeIn,ST1.SettingValue) TimeIn
				,(cast(SUBSTRING(ST3.SettingValue,1,3) as int)*60+cast(SUBSTRING(ST3.SettingValue,5,2) as int))/ 60 TimeOffset
				into #ListOfUsers
			FROM   (SELECT u1.* FROM Organization_Users U1 
				LEFT JOIN WorkingTime_AllowDevices A 
				ON U1.userno = a.userno	
				WHERE COALESCE(ContentAllow, 'true') ILIKE '%true%'
				AND (p_Uid = '' OR LOWER(U1.UserID) ILIKE '%' || p_Uid || '%')
				AND (p_UName = '' OR LOWER(U1.Name) ILIKE '%' || p_UName || '%')
				AND (p_UNameEn = '' OR LOWER(U1.Name_EN) ILIKE '%' || p_UNameEn || '%')
				AND (U1.Enabled = TRUE OR  U1.ModDate >= d_to)
				AND U1.IsVirtual = FALSE
			) U
			left join Organization_BelongToDepartment  B  ON U.UserNo = B.UserNo  AND U.IsVirtual = FALSE and B.IsDefault = TRUE
			INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
			INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
			LEFT JOIN Organization_Duties DT  ON DT.DutyNo = B.DutyNo
			LEFT JOIN WorkingTime_SettingGroup G ON U.GroupId = G.ID
			LEFT JOIN (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 1) ST1 ON 1 = 1
			LEFT JOIN (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 7) ST3 ON 1 = 1
			LEFT JOIN Organization_SortingEachDepartment S ON S.UserNo = U.UserNo and S.DepartNo = workingtime_reportnews.p_departno
			WHERE (p_DepartNo = 0 OR B.DepartNo IN (SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(p_DepartNo, 0)))
			AND ( (p_GroupNo = 0 OR U.GroupId = workingtime_reportnews.p_groupno) OR (p_GroupNo !=  0 AND U.GroupId = workingtime_reportnews.p_groupno))

			SELECT T.UserNo, T.TimeType, T.CheckTimeFull, T.CheckTimeC , T.StarWorking, Provider , T.WorkingDayC
			INTO #WKTIME
			FROM WorkingTime_Times T
			WHERE t.WorkingDayC BETWEEN p_From AND p_To and COALESCE(t.status,0) != 1

			SELECT e.UserNo, e.WorkingDayC
			INTO #WKEdit
			FROM #WKTIME e
			WHERE e.Provider = 999 
			group by e.UserNo, e.WorkingDayC

	---------------------------- End Filter user hide when no permission-------------------------

		IF NOW() <d_to SET p_To = CONVERT(VARCHAR, NOW(), 112)

	
	SELECT L.UserNo, L.Name, L.Name_EN, L.UserID, L.DepartName, L.DepartName_EN, L.PositionName, L.PositionName_EN
			, TotalNoCheckIn =COALESCE(SUM(TotalNoCheckIn),0)
			, TotalNoCheckOut =  COALESCE(SUM(TotalNoCheckOut),0)
			, TotalLate =  COALESCE(sum(Late),0)
			, TotalEdit =  COALESCE(Sum(Edit),0)
			, TimeWork = COALESCE(C.TimeWork,0)
			, DayOff = COALESCE(SUM(Offtime),0)
			, TimeWork2 =  max(COALESCE(C.TimeWork2,0) + COALESCE( WT.SumTimeType,0))
			, Vacation = COALESCE(sum(SumTimeTypeVacation ),0)
			---20241112 is it okey?
			,quatertoff  = COALESCE(sum(quatertoff ),0)
			,haftoff  = COALESCE(sum(haftoff ),0)
			,alloff  = COALESCE(sum(alloff ),0)
			, TotalCheckIn = COALESCE(sum(SumTimeTypeIn ),0)
			, TotalCheckOut =  COALESCE(sum(SumTimeTypeOut ),0)
	FROM #ListOfUsers L
	LEFT JOIN 
	(
       SELECT T.UserNo, MIN(CheckTimeC) CheckTimeC, MIN(StarWorking) StarWorking
			,Edit = (select count(*) from #WKEdit w where w.UserNo = T.UserNo )
			,Sum(CASE WHEN t.TimeType = 1 THEN 1 ELSE 0 END) SumTimeTypeIn
			,Sum(CASE WHEN t.TimeType = 3 THEN 1 ELSE 0 END) SumTimeTypeOut
			,sum(case when t.TimeType BETWEEN -6 and -1  THEN 1 ELSE 0 end ) SumTimeTypeVacation
			,sum(case when T.TimeType > 0 THEN 0 ELSE CASE WHEN (T.TimeType = -2 or T.TimeType = -3) then 4 else case when (T.TimeType = -1 or T.TimeType = -4 or T.TimeType = -5 or T.TimeType = -6) then 8 else 0 end END end) as SumTimeType

			,Sum( CASE WHEN (t.CheckTimeC >  (cast(LEFT(t.StarWorking,2) as int)*60+ cast(SUBSTRING(t.StarWorking,3,2) as int))) AND t.TimeType = 1 THEN 1 ELSE 0 END) as Late
						---20241112 is it okey?
			,sum(case WHEN (T.TimeType = -7) then 1 else 0 END ) as quatertoff
			,sum(case WHEN (T.TimeType = -8) then 1 else 0 END ) as haftoff
			,sum(case WHEN (T.TimeType = -9) then 1 else 0 END ) as alloff
			, TotalNoCheckIn =public."workingTime_CountNocheck"(cast(p_From as int), cast(p_To as int), 1, T.UserNo)
			, TotalNoCheckOut =public."workingTime_CountNocheck"(cast(p_From as int), cast(p_To as int), 3, T.UserNo)
			, Offtime = public."workingTime_CountNocheck2"(cast(p_From as int), cast(p_To as int),  T.UserNo)
	   FROM (
			select T.UserNo, MIN(CheckTimeC) CheckTimeC, MIN(StarWorking) StarWorking
				--,max(Provider) Provider 
				,TimeType
			from #WKTIME t GROUP BY T.UserNo, WorkingDayC, TimeType
	   ) T 
	   GROUP BY T.UserNo
	) AS WT  ON WT.UserNo = L.UserNo
	LEFT JOIN
	(
		SELECT  SUM(CASE WHEN CX.status = 1 THEN CX.TimeWork ELSE 0 END) TimeWork
				,SUM(CASE WHEN CX.status = 1 THEN CX.TimeWork ELSE 0 END) TimeWork2  
				, COUNT(CX.UserNo) DayOn
				, CX.UserNo
		FROM WorkingTime_Calculater CX WHERE WorkingDay  BETWEEN p_From AND p_To
		GROUP BY CX.UserNo
	) C ON C.UserNo = L.UserNo  
	GROUP BY L.UserNo, L.Name, L.Name_EN, L.UserID, L.DepartName, L.DepartName_EN, L.PositionName, L.PositionName_EN, SortNo, PSortNo, DTSortNo, C.TimeWork, C.TimeWork2, C.DayOn
	,WT.SumTimeType, wt.SumTimeTypeIn, wt.SumTimeTypeOut,wt.SumTimeTypeVacation
	,WT.TotalNoCheckIn
	,WT.TotalNoCheckOut
	,WT.Offtime
	ORDER BY COALESCE(SortNo,999), PSortNo, DTSortNo, L.Name ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
