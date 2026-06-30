-- ─── FUNCTION: workingtime_employeenocheckout ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_employeenocheckout(timestamp without time zone, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.workingtime_employeenocheckout(
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
	FROM  Organization_Users U  where U.UserNo = workingtime_employeenocheckout.userno;	
	  RETURN QUERY
	  SELECT i.DateInsert AS "Date"
			,CONVERT(date,DateInsert) as DateCheck
			, 1 as TimeType
			, NULL as  ContentDate
			, NULL as BeaconInfo
			, NULL as Provider
	  FROM WorkingTime_DateInsert i
		INNER JOIN ListOfUsers L ON 1 = 1
	  WHERE   i.DateInsert <=workingtime_employeenocheckout.todate  
		AND  i.DateInsert >= workingtime_employeenocheckout.fromdate
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
						AND wt.TimeType = 3 and  wt.UserNo = workingtime_employeenocheckout.userno
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
