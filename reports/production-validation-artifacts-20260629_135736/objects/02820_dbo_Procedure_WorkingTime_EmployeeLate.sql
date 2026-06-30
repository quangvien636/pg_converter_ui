-- ─── PROCEDURE→FUNCTION: workingtime_employeelate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.workingtime_employeelate(timestamp without time zone, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.workingtime_employeelate(
    IN fromdate timestamp without time zone,
    IN todate timestamp without time zone,
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    checkintimetext character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF(ToDate > NOW())
		ToDate := NOW();
		CheckInTimeText := (SELECT SettingValue FROM public."WorkingTime_Settings" where SettingNo = 1);
		RETURN QUERY
		SELECT  T.WorkingDayOfCompany AS "Date",
				U.UserNo AS "RegUserNo",
				T.CheckDateTimeOffset AS "CheckInFirst",
				(SELECT /* TOP 1 */ CheckDateTimeOffset
					FROM WorkingTime_Times 
						INNER JOIN WorkingTime_Times_v2 ON WorkingTime_Times.WorkingNo = WorkingTime_Times_v2.WorkingNo
					WHERE WorkingTime_Times_v2.WorkingDayOfCompany = T.WorkingDayOfCompany AND WorkingTime_Times.TimeType IN (3,6) AND WorkingTime_Times.UserNo = U.UserNo
					ORDER BY CheckDateTimeOffset DESC
				) AS "CheckOutLast",
				T.BeaconInfo,
				T.Provider
		FROM Organization_Users U INNER JOIN 
		(
			SELECT ROW_NUMBER()OVER(PARTITION BY wt2.WorkingDayOfCompany,wt.UserNo,wt.TimeType ORDER BY wt2.CheckDateTimeOffset) AS RN
					,wt2.WorkingDayOfCompany
					,wt.UserNo
					,wt.WorkingNo
					,wt2.CheckDateTimeOffset
					,wt.Latitude
					,wt.Longitude
					,wt.IpServer
					,wt.Distance
					,wt.LatCompany
					,wt.LngCompany
					,wt.TimeType
					,wt.Provider
					,wt.BeaconInfo
					,COALESCE(wr.Status, 1) AS Status
					,COALESCE(wt.StarWorking,CheckInTimeText) StarWorking
					,wt.CheckTime
					,WT.TimeOffset
					FROM WorkingTime_Times wt 
						INNER JOIN WorkingTime_Times_v2 wt2 ON wt.WorkingNo = wt2.WorkingNo
						LEFT JOIN WorkingTime_RequestCorrectionTime wr ON wt.WorkingNo = wr.WorkingNo

					WHERE wt2.WorkingDayOfCompany BETWEEN CAST(CONVERT(VARCHAR(8),FromDate,112) AS INT) AND CAST(CONVERT(VARCHAR(8),ToDate,112) AS INT)
						AND wt.TimeType IN (1,8)

		) AS T ON U.UserNo = T.UserNo AND U.Enabled = TRUE AND U.UserID <> '' 
		WHERE DATEPART(Minute, t.CheckDateTimeOffset)+ DATEPART(Hour, t.CheckDateTimeOffset)*60   > (cast(LEFT(StarWorking,2) as int)*60+ cast(SUBSTRING(StarWorking,3,2) as int)) 
			  AND T.RN = 1
			  AND T.Status = 1
			  AND T.UserNo = workingtime_employeelate.userno
		ORDER BY Date;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
