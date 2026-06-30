-- ─── FUNCTION: workingtime_getempmonthstats ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getempmonthstats();
CREATE OR REPLACE FUNCTION public.workingtime_getempmonthstats(
) RETURNS TABLE(
    col1 text,
    workingday text,
    timetype text,
    checktime text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT
		UNO,
		UserName,
		Months,
		SUM(출근+지각) As WorkStart,
		SUM(지각) As Late,
		SUM(외근) As Road,
		SUM(복귀) As Back,
		SUM(퇴근+야근+철야) As WorkEnd,
		SUM(야근) As OverTime,
		SUM(철야) As OverNight
	FROM
	(
		SELECT * FROM
		(
			SELECT
				UserNo As UNO, 
				UserNo,
				public."COMNGetUserName"(UserNo) as UserName,
				Convert(INT,(SUBSTRING(CONVERT(VARCHAR(8),WorkingDay),5,2))) AS Months,
				CheckTime,
				CASE WHEN TimeType = '1' AND CheckTime <= '090000' THEN '출근' 
					 WHEN TimeType = '1' AND CheckTime BETWEEN '090001' AND '175959'  THEN '지각' 
					 WHEN TimeType = '2' THEN '외근'
					 WHEN TimeType = '3' AND CheckTime BETWEEN '180000' AND '185959' THEN '퇴근' 
					 WHEN TimeType = '3' AND CheckTime BETWEEN '190000' AND '235959' THEN '야근' 
					 WHEN TimeType = '3' AND CheckTime BETWEEN '000000' AND '085959' THEN '철야'
					 WHEN TimeType = '4' THEN '복귀'
				END AS StatusDesc
			FROM
			(
				SELECT
					DISTINCT
					UserNo,
					WorkingDay,
					TimeType,
					MIN(CheckTime) AS CheckTime
				FROM WorkingTime_Times
				WHERE CONVERT(INT,SUBSTRING(CONVERT(VARCHAR(8),WorkingDay),1,6)) = CONVERT(INT, Year+Month)
				GROUP BY UserNo, WorkingDay, TimeType
			) A
		) T
		--ORDER BY WorkingDay
		PIVOT ( COUNT(UserNo) FOR StatusDesc IN (출근,지각,외근,복귀,퇴근,야근,철야)) AS PVT
	) T
	WHERE UNO > 0
	GROUP BY UNO, UserName, Months
	ORDER BY UserName;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
