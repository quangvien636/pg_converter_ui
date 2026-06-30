-- ─── FUNCTION: workingtime_reportstotals ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_reportstotals(integer, integer, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_reportstotals(
    p_from integer,
    p_to integer,
    p_departno integer DEFAULT 0,
    p_groupno integer DEFAULT 0,
    p_uid character varying DEFAULT '',
    p_uname character varying DEFAULT '',
    p_unameen character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN





insert into offunos(uno)				
SELECT t.UserNo
FROM WorkingTime_Times t
where t.TimeType = -2 and WorkingDayC BETWEEN p_From AND p_To;

--- off morning and late after noon +5;
insert into lateunos(uno)	
SELECT t.UserNo
FROM WorkingTime_Times t
JOIN WorkingTime_Times_v2 wt2 ON t.WorkingNo = wt2.WorkingNo
where t.TimeType = 1 and  t.UserNo in (select uno from offunos) AND T.Provider != 999 and COALESCE(WorkingDayC, WT2.WorkingDayOfCompany) BETWEEN p_From AND p_To
and DATEPART(Minute, wt2.CheckDateTimeOffset)+ DATEPART(Hour, wt2.CheckDateTimeOffset)*60 > ((cast(LEFT(T.StarWorking,2) as int)+5)*60+ cast(SUBSTRING(T.StarWorking,3,2) as int))

-----late without off morning

insert into lateunos(uno)	
SELECT t.UserNo
FROM WorkingTime_Times t
JOIN WorkingTime_Times_v2 wt2 ON t.WorkingNo = wt2.WorkingNo
where t.TimeType = 1 AND T.Provider != 999 and COALESCE(WorkingDayC, WT2.WorkingDayOfCompany) BETWEEN p_From AND p_To
and DATEPART(Minute, wt2.CheckDateTimeOffset)+ DATEPART(Hour, wt2.CheckDateTimeOffset)*60 > (cast(LEFT(T.StarWorking,2) as int)*60+ cast(SUBSTRING(T.StarWorking,3,2) as int))
and t.UserNo not in
(
	select uno from offunos
)


	SELECT B.UserNo into #U1
	     FROM  (SELECT u1.* FROM Organization_Users U1 
				LEFT JOIN WorkingTime_AllowDevices A 
				ON U1.userno = a.userno	
				WHERE COALESCE(ContentAllow, 'true') ILIKE '%true%'
				AND (p_Uid = '' OR LOWER(U1.UserID) ILIKE '%' || p_Uid || '%')
				AND (p_UName = '' OR LOWER(U1.Name) ILIKE '%' || p_UName || '%')
				AND (p_UNameEn = '' OR LOWER(U1.Name_EN) ILIKE '%' || p_UNameEn || '%')
				AND U1.Enabled = TRUE AND U1.IsVirtual = FALSE
		) U
		left join Organization_BelongToDepartment  B  ON U.UserNo = B.UserNo  AND U.IsVirtual = FALSE and B.IsDefault = TRUE
		WHERE (p_DepartNo = 0 OR B.DepartNo IN (SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(p_DepartNo, 0)))
		AND ( (p_GroupNo = 0 OR U.GroupId = workingtime_reportstotals.p_groupno) OR (p_GroupNo !=  0 AND U.GroupId = workingtime_reportstotals.p_groupno));

		SELECT wt.UserNo
				, wt.TimeType 
				,COALESCE(wt.StarWorking,'0830') StarWorking
				,wt2.CheckDateTimeOffset
				,wt.WorkingDay
				,wt.Provider
		INTO #W1  
		FROM WorkingTime_Times wt
		LEFT JOIN WorkingTime_Times_v2 wt2 ON wt.WorkingNo = wt2.WorkingNo
		WHERE COALESCE(WT.WorkingDayC ,WT2.WorkingDayOfCompany) BETWEEN p_From AND p_To
		and COALESCE(wt.status,0) != 1
         SELECT (SELECT COUNT(UserNo) FROM #U1) TotalStaff
			   ,(SELECT COUNT( UserNo ) FROM #U1 WHERE UserNo NOT IN (SELECT UserNo FROM #W1 WHERE TimeType = 1 )) AS TotalNoCheckIn
			   ,(SELECT COUNT( UserNo ) FROM #U1 WHERE UserNo NOT IN (SELECT UserNo FROM #W1 WHERE TimeType = 3 )) AS TotalNoCheckOut
			   ,(SELECT COUNT( uno ) FROM lateunos ) AS TotalLate --20240503
				,(SELECT COUNT( UserNo ) FROM #U1 WHERE UserNo NOT IN (SELECT UserNo FROM #W1)) AS DayOff
				,(SELECT COUNT( UserNo ) FROM #U1 WHERE UserNo IN (SELECT UserNo FROM #W1 WHERE TimeType in(2,4))) AS TotalOutSide
				,(SELECT COUNT( UserNo ) FROM #U1 WHERE UserNo IN (SELECT UserNo FROM #W1 WHERE Provider = 999)) AS TotalEdit	
				,(SELECT COUNT( UserNo ) FROM #U1 WHERE UserNo IN (SELECT UserNo FROM #W1 WHERE TimeType between -7 and -1 or TimeType < -10)) AS DayOffVacation
				---20241107
				,(SELECT COUNT( UserNo ) FROM #U1 WHERE UserNo IN (SELECT UserNo FROM #W1 WHERE TimeType = -7)) AS quatertoff
				,(SELECT COUNT( UserNo ) FROM #U1 WHERE UserNo IN (SELECT UserNo FROM #W1 WHERE TimeType = -8)) AS haftoff
				,(SELECT COUNT( UserNo ) FROM #U1 WHERE UserNo IN (SELECT UserNo FROM #W1 WHERE TimeType = -9)) AS alloff
				---20241126
				,(SELECT COUNT( UserNo ) FROM #U1 WHERE UserNo IN (SELECT UserNo FROM #W1 WHERE TimeType = 1)) AS TotalCheckIn
				,(SELECT COUNT( UserNo ) FROM #U1 WHERE UserNo IN (SELECT UserNo FROM #W1 WHERE TimeType = 3)) AS TotalCheckOut;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
