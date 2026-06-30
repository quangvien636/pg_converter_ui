-- ─── FUNCTION: workingtime_timeworkforuser_funtion_v2 ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_timeworkforuser_funtion_v2(integer);
CREATE OR REPLACE FUNCTION public.workingtime_timeworkforuser_funtion_v2(
    userno integer
) RETURNS character varying
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
DECLARE
    result character varying;
    workingtime_cursor cursor;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


			,WorkingNo INT
			,TimeType INT
			,CheckTime DATETIMEOFFSET(7)
			,StartTimeWork DATETIMEOFFSET(7)
			,EndTimeWork DATETIMEOFFSET(7)
			,CheckInStatus BIT = 0
			,CheckOutStatus BIT = 0
			,Workingtime FLOAT = 0
			,FirstEnter DATETIMEOFFSET(7)
			,LastEixt DATETIMEOFFSET(7)
			,DateTimeOffsetNow DATETIMEOFFSET(7) = SYSDATETIMEOFFSET()
			,CountEnter INT = 0


	SET WorkingTime_Cursor = CURSOR FAST_FORWARD
	FOR
		SELECT WorkingNo, CheckTime, TimeType
		FROM public."WorkingTime_Get"(UserNo, WorkingDay)
		ORDER BY CheckTime

	OPEN WorkingTime_Cursor

	FETCH NEXT FROM WorkingTime_Cursor

	INTO WorkingNo, CheckTime, TimeType

	WHILE @FETCH_STATUS = 0
	   BEGIN

			BEGIN -- CHECK FIRST ENTER AND LAST EXIT
				IF (TimeType = 8 OR  TimeType = 5) AND CountEnter = 0 BEGIN
					--PRINT 'FIRST ENTER'
					SET FirstEnter = CheckTime
					SET CountEnter = 1
					--SELECT FirstEnter AS ENTER
				END
				ELSE IF (TimeType = 6 OR  TimeType = 7)AND CountEnter IN (1,2) BEGIN
					--PRINT 'LAST EXIT'
					SET LastEixt = CheckTime
					--SELECT LastEixt AS EXITS
				END
			END
			
			BEGIN -- Calculator Time
				IF TimeType = 1 AND CheckInStatus = 0   BEGIN -- First Check in 
					--PRINT 'FIRST CHECK IN'
					SET StartTimeWork = CheckTime

					SET CheckInStatus = 1
					SET CheckOutStatus = 0
					
					IF CountEnter = 1 BEGIN
						SET Workingtime = Workingtime || public."WorkingTime_CalculatorTimeWork"(FirstEnter, StartTimeWork)
						SET CountEnter = 2
					END
				END
				ELSE IF TimeType = 3 AND CheckInStatus = 1 BEGIN -- Check Out times
					--PRINT 'FIRST CHECK OUT'
					SET EndTimeWork = CheckTime
					SET CheckInStatus = 0
					SET CheckOutStatus = 1
					
					SET Workingtime = Workingtime || public."WorkingTime_CalculatorTimeWork"(StartTimeWork, EndTimeWork)
					--SELECT  StartTimeWork AS CIN, EndTimeWork AS COUT, CONVERT(VARCHAR(8),DATEADD(ms,public."WorkingTime_CalculatorTimeWork"(StartTimeWork, EndTimeWork),0),114)
				END
				ELSE IF TimeType = 3 AND CheckInStatus = 0 AND CheckOutStatus = 1 BEGIN -- Check Out multiple times
					--PRINT 'CHECK OUT'
					SET StartTimeWork = EndTimeWork
					SET EndTimeWork = CheckTime
					SET Workingtime = Workingtime || public."WorkingTime_CalculatorTimeWork"(StartTimeWork, EndTimeWork)
					--SELECT  StartTimeWork AS CIN, EndTimeWork AS COUT, CONVERT(VARCHAR(8),DATEADD(ms,public."WorkingTime_CalculatorTimeWork"(StartTimeWork, EndTimeWork),0),114)
				END
			END

			FETCH NEXT FROM WorkingTime_Cursor
			INTO WorkingNo, CheckTime, TimeType
	   END
	CLOSE WorkingTime_Cursor
	DEALLOCATE WorkingTime_Cursor

	BEGIN --First Enter and Last Exit
		IF CheckInStatus = 1 AND CheckOutStatus = 0  BEGIN -- CHECK IN - NO CHECK OUT
			IF CAST(WorkingDay AS INT) < CONVERT (VARCHAR (20), DateTimeOffsetNow, 112) AND StartTimeWork < LastEixt BEGIN -- CHECK IN < EXIT
				SET Workingtime = Workingtime || public."WorkingTime_CalculatorTimeWork"(StartTimeWork, LastEixt)
			END
			ELSE IF CAST(WorkingDay AS INT) = CONVERT (VARCHAR (20), DateTimeOffsetNow, 112) AND  StartTimeWork < DateTimeOffsetNow BEGIN
				SET Workingtime = Workingtime || public."WorkingTime_CalculatorTimeWork"(StartTimeWork, DateTimeOffsetNow)
			END
		END
		ELSE IF CheckInStatus = 0 AND CheckOutStatus = 1 AND EndTimeWork < LastEixt BEGIN
			SET Workingtime = Workingtime || public."WorkingTime_CalculatorTimeWork"(EndTimeWork, LastEixt)
		END
		ELSE IF CheckInStatus = 0 AND CheckOutStatus = 0 AND CountEnter = 1 BEGIN
			IF  FirstEnter < LastEixt BEGIN
				SET Workingtime = Workingtime || public."WorkingTime_CalculatorTimeWork"(FirstEnter, LastEixt)
			END
			ELSE IF CAST(WorkingDay AS INT) = CONVERT (VARCHAR (20), DateTimeOffsetNow, 112) AND  FirstEnter < DateTimeOffsetNow BEGIN
				SET Workingtime = Workingtime || public."WorkingTime_CalculatorTimeWork"(FirstEnter, DateTimeOffsetNow)
			END
		END
	END

	BEGIN -- Convert milisecorn to string time 00:00:00
		--IF Workingtime = 0 BEGIN -- if Working tim = 0 return not calculated
		--	SET RESULT = '0'
		--END
		--ELSE BEGIN
			SET RESULT = CONVERT(VARCHAR(8),DATEADD(ms,Workingtime,0),114)
		--END
	END
	RETURN RESULT;
	--SELECT RESULT
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
