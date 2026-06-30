-- ─── FUNCTION: workingtime_get ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_get(integer);
CREATE OR REPLACE FUNCTION public.workingtime_get(
    userno integer
) RETURNS TABLE(
    workingno integer,
    checktime datetimeoffset,
    timetype integer
)
-- TODO: TOP was preserved as comment; add LIMIT manually
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
#variable_conflict use_column
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


			,CountWorkingNoOnday INT = 0
			,MaxCheckType INT = 0
			,MinCheckType INT = 0
			,temp_WorkingNo INT 
			,temp_TimeType INT
			,startDate DATETIMEOFFSET
			,endDate DATETIMEOFFSET
			,temp_CheckTime DATETIMEOFFSET


	SELECT CountWorkingNoOnday = COUNT(wt.WorkingNo)
		FROM WorkingTime_Times wt
			INNER JOIN WorkingTime_Times_v2 wt2 ON wt.WorkingNo = wt2.WorkingNo
		WHERE wt2.WorkingDayOfCompany = WorkingDay
			AND wt.UserNo = workingtime_get.userno

	--IF CountWorkingNoOnday = 0 BEGIN
	--	--PRINT 'In day no have Check'
	--	RETURN
	--END
	IF CountWorkingNoOnday > 0 BEGIN
		--INSERT INTO DATA IN  ;
		INSERT INTO ReturnWorkingTime (WorkingNo, CheckTime, TimeType)
			RETURN QUERY
			SELECT	wt.WorkingNo,wt2.CheckDateTimeOffset,wt.TimeType
				FROM WorkingTime_Times wt INNER JOIN WorkingTime_Times_v2 wt2 ON wt.WorkingNo = wt2.WorkingNo
				WHERE wt2.WorkingDayOfCompany = WorkingDay
					AND wt.UserNo = workingtime_get.userno
					AND wt.TimeType IN (1,3,8,6,5,7)
				ORDER BY wt2.CheckDateTimeOffset

		IF CountWorkingNoOnday = 1 BEGIN
			--PRINT 'In day have one Check'
			RETURN QUERY
			SELECT /* TOP 1 */ MaxCheckType = TimeType, startDate =  CheckTime FROM ReturnWorkingTime

			IF (MaxCheckType = 1) OR (MaxCheckType = 8) OR (MaxCheckType = 5) BEGIN
				--PRINT '	Start In day have one Check : CheckIn'
				SET startDate = DATEADD(SECOND,1, startDate)
				SET endDate = DATEADD(HOUR,TimeOutCheckIn, startDate)

				RETURN QUERY
				SELECT	/* TOP 1 */ temp_WorkingNo = wt.WorkingNo, temp_CheckTime = wt2.CheckDateTimeOffset, temp_TimeType = wt.TimeType
				FROM WorkingTime_Times wt INNER JOIN WorkingTime_Times_v2 wt2 ON wt.WorkingNo = wt2.WorkingNo
				WHERE wt2.CheckDateTimeOffset BETWEEN startDate AND endDate
					AND wt.UserNo = workingtime_get.userno
					AND wt.TimeType IN (1,3,8,6,5,7)
				ORDER BY wt2.CheckDateTimeOffset DESC

				IF(temp_TimeType = 3) OR (temp_TimeType = 6) OR (temp_TimeType = 7) BEGIN -- AUTO CHECK OUT : 23:59:59 SAME DAY;
					INSERT INTO ReturnWorkingTime (WorkingNo, CheckTime, TimeType) 
							VALUES (temp_WorkingNo, TODATETIMEOFFSET(DATEADD(HOUR,0, WorkingDay || ' 23:59:59'), datepart(TZOFFSET,startDate)), temp_TimeType)
				END

				--PRINT '	End   In day have one Check : CheckIn'
			END
			ELSE IF (MaxCheckType) = 3  OR (MaxCheckType = 6) OR (MaxCheckType = 7) BEGIN
				--PRINT '	Start In day have one Check : CheckOut'
				SET startDate = DATEADD(SECOND,-1, startDate)
				SET endDate = DATEADD(HOUR,-TimeOutCheckIn, startDate)

				RETURN QUERY
				SELECT	/* TOP 1 */ temp_WorkingNo = wt.WorkingNo, temp_CheckTime = wt2.CheckDateTimeOffset, temp_TimeType = wt.TimeType
				FROM WorkingTime_Times wt INNER JOIN WorkingTime_Times_v2 wt2 ON wt.WorkingNo = wt2.WorkingNo
				WHERE wt2.CheckDateTimeOffset BETWEEN endDate AND startDate
					AND wt.UserNo = workingtime_get.userno
					AND wt.TimeType IN (1,3,8,6,5,7)
				ORDER BY wt2.CheckDateTimeOffset DESC

				IF (temp_TimeType = 1) OR (temp_TimeType = 8) OR (temp_TimeType = 5) BEGIN -- AUTO CHECK IN : 00:00:00 SAME DAY
					--PRINT '		Last Check : check in';
					INSERT INTO ReturnWorkingTime (WorkingNo, CheckTime, TimeType) 
							VALUES (temp_WorkingNo, TODATETIMEOFFSET(DATEADD(HOUR,0, WorkingDay || ' 00:00:00'), datepart(TZOFFSET,startDate)), temp_TimeType)
				END
				--PRINT '	End   In day have one Check : CheckOut'
			END
		END
		ELSE BEGIN
			--PRINT 'In day more than one Check'

			--PRINT '	select max check'
			RETURN QUERY
			SELECT /* TOP 1 */ MaxCheckType = TimeType, startDate =  CheckTime FROM ReturnWorkingTime ORDER BY CheckTime DESC
			
			IF (MaxCheckType = 1) OR (MaxCheckType = 8) OR (MaxCheckType = 5) BEGIN --If max check = 3 or 6 then select last <---- check
				SET startDate = DATEADD(SECOND,1, startDate)
				SET endDate = DATEADD(HOUR,TimeOutCheckIn, startDate)

				RETURN QUERY
				SELECT	/* TOP 1 */ temp_WorkingNo = wt.WorkingNo, temp_CheckTime = wt2.CheckDateTimeOffset, temp_TimeType = wt.TimeType
				FROM WorkingTime_Times wt INNER JOIN WorkingTime_Times_v2 wt2 ON wt.WorkingNo = wt2.WorkingNo
				WHERE wt2.CheckDateTimeOffset BETWEEN startDate AND endDate
					AND wt.UserNo = workingtime_get.userno
					AND wt.TimeType IN (1,3,8,6,5,7)
				ORDER BY wt2.CheckDateTimeOffset

				IF(temp_TimeType = 3) OR (temp_TimeType = 6) OR (temp_TimeType = 7) BEGIN -- AUTO CHECK OUT : 23:59:59 SAME DAY;
					INSERT INTO ReturnWorkingTime (WorkingNo, CheckTime, TimeType) 
							VALUES (temp_WorkingNo, TODATETIMEOFFSET(DATEADD(HOUR,0, WorkingDay || ' 23:59:59'), datepart(TZOFFSET,startDate)), temp_TimeType)
				END 
			END

			--PRINT '	select min check'
			RETURN QUERY
			SELECT /* TOP 1 */ MinCheckType = TimeType, startDate =  CheckTime FROM ReturnWorkingTime ORDER BY CheckTime 

			IF (MinCheckType = 3)  OR (MinCheckType = 6)  OR (MinCheckType = 7) BEGIN --		if last check = 1 or 8 then select
				SET startDate = DATEADD(SECOND,-1, startDate)
				SET endDate = DATEADD(HOUR,-TimeOutCheckIn, startDate)

				RETURN QUERY
				SELECT	/* TOP 1 */ temp_WorkingNo = wt.WorkingNo, temp_CheckTime = wt2.CheckDateTimeOffset, temp_TimeType = wt.TimeType
				FROM WorkingTime_Times wt INNER JOIN WorkingTime_Times_v2 wt2 ON wt.WorkingNo = wt2.WorkingNo
				WHERE wt2.CheckDateTimeOffset BETWEEN endDate AND startDate
					AND wt.UserNo = workingtime_get.userno
					AND wt.TimeType IN (1,3,8,6,5,7)
				ORDER BY wt2.CheckDateTimeOffset

				IF (temp_TimeType = 1) OR (temp_TimeType = 8)  OR (temp_TimeType = 5) BEGIN -- AUTO CHECK IN : 00:00:00 SAME DAY
					--PRINT '		Last Check : check in';
					INSERT INTO ReturnWorkingTime (WorkingNo, CheckTime, TimeType) 
							VALUES (temp_WorkingNo, TODATETIMEOFFSET(DATEADD(HOUR,0, WorkingDay || ' 00:00:00'), datepart(TZOFFSET,startDate)), temp_TimeType)
				END
			END				
		END
	END
	--SELECT * FROM ReturnWorkingTime ORDER BY CheckTime

	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
