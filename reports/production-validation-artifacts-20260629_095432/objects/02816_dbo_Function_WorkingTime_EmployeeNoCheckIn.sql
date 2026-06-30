-- ─── FUNCTION: workingtime_employeenocheckin ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_employeenocheckin(timestamp without time zone, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.workingtime_employeenocheckin(
    fromdate timestamp without time zone,
    todate timestamp without time zone,
    userno integer
) RETURNS TABLE(
    rn text,
    workingdayc text,
    userno text,
    provider text,
    status text
)
AS $function$
DECLARE
    listofusers table (
		userno				int
	);
BEGIN


	IF(ToDate>NOW())
		Set ToDate = NOW()


	INSERT INTO ListOfUsers 
	RETURN QUERY
	SELECT 
		U.UserNo
	FROM  Organization_Users U  where U.UserNo = workingtime_employeenocheckin.userno;	
	RETURN QUERY
	SELECT i.DateInsert AS "Date"
	  FROM WorkingTime_DateInsert i
		INNER JOIN ListOfUsers L ON 1 = 1
	  WHERE   i.DateInsert <=workingtime_employeenocheckin.todate  
		AND  i.DateInsert >= workingtime_employeenocheckin.fromdate
		AND i.DateInt not in (
		SELECT WorkingDayC FROM (
			SELECT ROW_NUMBER()OVER(PARTITION BY  wt.WorkingDayC,wt.UserNo,wt.TimeType ORDER BY wt.WorkingDayC) AS RN
					, wt.WorkingDayC
					,wt.UserNo
					,wt.Provider
					,COALESCE(wr.Status, 1) AS Status
					FROM WorkingTime_Times wt 
						LEFT JOIN WorkingTime_RequestCorrectionTime wr ON wt.WorkingNo = wr.WorkingNo
					WHERE  wt.WorkingDayC BETWEEN CAST(CONVERT(VARCHAR(8),FromDate,112) AS INT) 
						AND CAST(CONVERT(VARCHAR(8),ToDate,112) AS INT)
						AND wt.TimeType =1 and  wt.UserNo = workingtime_employeenocheckin.userno
		) AS temp
		WHERE temp.UserNo = L.UserNo 
				AND temp.Status = 1
				AND temp.RN = 1

		)
	  ORDER BY Date;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
