-- ─── FUNCTION: workingtime_get_workingtime_times ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_get_workingtime_times(integer);
CREATE OR REPLACE FUNCTION public.workingtime_get_workingtime_times(
    userno integer
) RETURNS TABLE(
    workingno integer,
    checktime timestamp without time zone,
    timetype integer,
    timeoffset double precision
)
-- TODO: TOP was preserved as comment; add LIMIT manually
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
#variable_conflict use_column
DECLARE
    lastchecktype integer;
    lastcheckin timestamp without time zone;
    lastcheckout timestamp without time zone;
    temp_workingno integer;
    temp_checktime timestamp without time zone;
    temp_timetype integer;
    temp_timeoffset double precision;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


















	SELECT CountCheck = COUNT(WorkingNo) 
		FROM WorkingTime_Times 
		WHERE UserNo = workingtime_get_workingtime_times.userno 
			AND  CONVERT(varchar(10), public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime), 112) = WorkingDay

	IF CountCheck = 0
	BEGIN
		RETURN QUERY
		SELECT /* TOP 1 */ LastCheckType = TimeType, startDate =  public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime)
			FROM WorkingTime_Times
			  where UserNo = workingtime_get_workingtime_times.userno 
				AND public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime) = 
					(SELECT MAX(public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime)) AS max_date FROM WorkingTime_Times 
						WHERE UserNo = workingtime_get_workingtime_times.userno
							AND TimeType IN (1,3)
							AND CONVERT(INT, CONVERT(VARCHAR(10), public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime), 112)) <= CONVERT(INT, WorkingDay) AND Provider IN (1,2,3,4,9))
			  ORDER BY WorkingNo DESC

		SET startDate = DATEADD(SECOND,1, startDate)
		SET endDate =  DATEADD(HOUR,TimeOutCheckIn, startDate)
		
		IF LastCheckType = 1
		BEGIN
			RETURN QUERY
			SELECT /* TOP 1 */ temp_WorkingNo = WorkingNo, temp_CheckTime = public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime), temp_TimeType = TimeType, temp_TimeOffset = TimeOffset
				FROM WorkingTime_Times
				WHERE UserNo = workingtime_get_workingtime_times.userno
					AND TimeType IN (1,3)
					AND public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime) BETWEEN startDate AND endDate
				ORDER BY CheckTime 
				
			IF(temp_TimeType = 3)
				BEGIN;
					INSERT INTO ReturnDepartments (WorkingNo, CheckTime, TimeType, TimeOffset) 
						VALUES (temp_WorkingNo, DATEADD(HOUR,0, WorkingDay || ' 00:00:00'), LastCheckType, temp_TimeOffset);
					INSERT INTO ReturnDepartments (WorkingNo, CheckTime, TimeType, TimeOffset) 
						VALUES (temp_WorkingNo, DATEADD(HOUR,0, WorkingDay || ' 23:59:59'), temp_TimeType, temp_TimeOffset)
				END
		END
	END
	ELSE
	BEGIN;
		INSERT INTO ReturnDepartments (WorkingNo, CheckTime, TimeType, TimeOffset)
		RETURN QUERY
		SELECT WorkingNo, public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime) AS CheckTime, TimeType, TimeOffset
			FROM WorkingTime_Times
			WHERE UserNo = workingtime_get_workingtime_times.userno 
				AND TimeType IN (1,3)
				AND  CONVERT(DATE,public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime)) = WorkingDay

		SELECT CountReturn = COUNT(WorkingNo) FROM ReturnDepartments
		IF CountReturn = 1
		BEGIN
			SELECT MaxCheckType = TimeType, startDate =  CheckTime FROM ReturnDepartments 
				WHERE CheckTime = (SELECT MAX(CheckTime) AS CheckTime FROM ReturnDepartments)

			IF MaxCheckType = 1
				BEGIN

					SET startDate = DATEADD(SECOND,1, startDate)
					SET endDate = DATEADD(HOUR,TimeOutCheckIn, startDate)

					RETURN QUERY
					SELECT /* TOP 1 */ temp_WorkingNo = WorkingNo, temp_CheckTime = public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime), temp_TimeType = TimeType, temp_TimeOffset = TimeOffset
						FROM WorkingTime_Times
						WHERE UserNo = workingtime_get_workingtime_times.userno 
							AND TimeType IN (1,3)
							AND  public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime) BETWEEN startDate AND endDate
						ORDER BY CheckTime 
					IF(temp_TimeType = 3);
						INSERT INTO ReturnDepartments (WorkingNo, CheckTime, TimeType, TimeOffset) 
							VALUES (temp_WorkingNo, DATEADD(HOUR,0, WorkingDay || ' 23:59:59'), temp_TimeType, temp_TimeOffset)

				END
				ELSE IF MaxCheckType = 3
				BEGIN
					SET startDate = DATEADD(SECOND,-1, startDate)
					SET endDate = DATEADD(HOUR,-TimeOutCheckIn, startDate)

					RETURN QUERY
					SELECT /* TOP 1 */ temp_WorkingNo = WorkingNo, temp_CheckTime = public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime), temp_TimeType = TimeType, temp_TimeOffset = TimeOffset
						FROM WorkingTime_Times
						WHERE UserNo = workingtime_get_workingtime_times.userno 
							AND TimeType IN (1,3)
							AND public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime) BETWEEN endDate AND startDate
						ORDER BY CheckTime DESC
					IF temp_TimeType = 1
					BEGIN;
						INSERT INTO ReturnDepartments (WorkingNo, CheckTime, TimeType, TimeOffset) 
							VALUES (temp_WorkingNo, DATEADD(HOUR,0, WorkingDay || ' 00:00:00'), temp_TimeType, temp_TimeOffset)
					END
					ELSE IF temp_TimeType <> 3
					BEGIN
						SELECT LastCheckIn = public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime), temp_TimeOffset = TimeOffset
						FROM WorkingTime_Times
						WHERE UserNo = workingtime_get_workingtime_times.userno 
							AND public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime) = 
								(SELECT MAX(public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime)) AS max_date FROM WorkingTime_Times 
									WHERE UserNo = workingtime_get_workingtime_times.userno 
										AND CONVERT(VARCHAR(10), public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime), 112) = CONVERT(VARCHAR(10), temp_CheckTime, 112)
										AND TimeType = 1 
										AND Provider in (1,2,3,4,9))
						
						SELECT LastCheckOut = public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime)
						FROM WorkingTime_Times
						WHERE UserNo = workingtime_get_workingtime_times.userno 
							AND public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime) = 
								(SELECT MAX(public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime)) AS max_date FROM WorkingTime_Times 
									WHERE UserNo = workingtime_get_workingtime_times.userno 
										AND CONVERT(VARCHAR(10), public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime), 112) = CONVERT(VARCHAR(10), temp_CheckTime, 112)
										AND TimeType = 3 
										AND Provider IN (1,2,3,4,9))

						IF LastCheckIn > LastCheckOut
						BEGIN;
							INSERT INTO ReturnDepartments (WorkingNo, CheckTime, TimeType, TimeOffset) 
								VALUES (temp_WorkingNo, DATEADD(HOUR,0, WorkingDay || ' 00:00:00'), 1 , temp_TimeOffset)	
						END
					END
				
				END
		END
		ELSE IF CountReturn>1
		BEGIN
			SELECT MaxCheckType = TimeType, startDate =  CheckTime FROM ReturnDepartments 
				WHERE CheckTime = (SELECT MAX(CheckTime) AS CheckTime FROM ReturnDepartments)

			IF MaxCheckType = 1
			BEGIN
				SET startDate = DATEADD(SECOND,1, startDate)
				SET endDate = DATEADD(HOUR,TimeOutCheckIn, startDate)

				RETURN QUERY
				SELECT /* TOP 1 */ temp_WorkingNo = WorkingNo, temp_CheckTime = public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime), temp_TimeType = TimeType, temp_TimeOffset = TimeOffset
					FROM WorkingTime_Times
					WHERE UserNo = workingtime_get_workingtime_times.userno 
						AND TimeType IN (1,3)
						AND public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime) BETWEEN startDate AND endDate
					ORDER BY CheckTime 

				IF(temp_TimeType = 3);
					INSERT INTO ReturnDepartments (WorkingNo, CheckTime, TimeType, TimeOffset) 
						VALUES (temp_WorkingNo, DATEADD(HOUR,0, WorkingDay || ' 23:59:59'), 3, temp_TimeOffset)

			END
			ELSE IF MaxCheckType <> 3
			BEGIN
				SELECT LastCheckIn = CheckTime, temp_TimeOffset = TimeOffset
				FROM ReturnDepartments
					WHERE CheckTime = (SELECT MAX(CheckTime) AS CheckTime FROM ReturnDepartments WHERE TimeType = 1)

				SELECT LastCheckOut = CheckTime
				FROM ReturnDepartments
					WHERE CheckTime = (SELECT MAX(CheckTime) AS CheckTime FROM ReturnDepartments WHERE TimeType = 3)

				IF LastCheckIn > LastCheckOut
				BEGIN
					SET startDate = DATEADD(SECOND,1, LastCheckIn)
					SET endDate =  DATEADD(HOUR,TimeOutCheckIn, startDate)

					RETURN QUERY
					SELECT /* TOP 1 */ temp_WorkingNo = WorkingNo, temp_CheckTime = public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime), temp_TimeType = TimeType, temp_TimeOffset = TimeOffset
					FROM WorkingTime_Times
					WHERE UserNo = workingtime_get_workingtime_times.userno 
						AND TimeType IN (1,3)
						AND public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime) BETWEEN startDate AND endDate
					ORDER BY CheckTime 

					IF(temp_TimeType = 3)
					BEGIN;
						INSERT INTO ReturnDepartments (WorkingNo, CheckTime, TimeType, TimeOffset) 
							VALUES (temp_WorkingNo, DATEADD(HOUR,0, WorkingDay || ' 23:59:59'), 3 , temp_TimeOffset)
					END
				END
			END

			SELECT MinCheckType = TimeType, startDate =  CheckTime FROM ReturnDepartments 
				WHERE CheckTime = (SELECT MIN(CheckTime) AS CheckTime FROM ReturnDepartments)
			IF MinCheckType = 3
			BEGIN
				SET startDate = DATEADD(SECOND,-1, startDate)
				SET endDate = DATEADD(HOUR,-TimeOutCheckIn, startDate)

				RETURN QUERY
				SELECT /* TOP 1 */ temp_WorkingNo = WorkingNo, temp_CheckTime = public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime), temp_TimeType = TimeType, temp_TimeOffset = TimeOffset
					FROM WorkingTime_Times
					WHERE UserNo = workingtime_get_workingtime_times.userno
						AND TimeType IN (1,3)
						AND public."AddWorkingDayTimes"(TimeOffset,WorkingDay,CheckTime) BETWEEN endDate AND startDate
					ORDER BY CheckTime DESC

				IF temp_TimeType = 1
				BEGIN;
					INSERT INTO ReturnDepartments (WorkingNo, CheckTime, TimeType, TimeOffset) 
						VALUES (temp_WorkingNo, DATEADD(HOUR,0, WorkingDay || ' 00:00:00'), 1, temp_TimeOffset)
				END
			END
		END
	END
	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
