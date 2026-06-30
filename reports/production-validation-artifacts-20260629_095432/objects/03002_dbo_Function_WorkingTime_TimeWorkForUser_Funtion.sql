-- ─── FUNCTION: workingtime_timeworkforuser_funtion ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_timeworkforuser_funtion(integer);
CREATE OR REPLACE FUNCTION public.workingtime_timeworkforuser_funtion(
    userno integer
) RETURNS character varying
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
DECLARE
    result character varying;
    workingtime double precision;
    starttimework timestamp without time zone;
    endtimework timestamp without time zone;
    endtimeworkingday character varying;
    dendtimeworkingday timestamp without time zone;
    checklunchstatus boolean;
    checkinstatus boolean;
    checkoutstatus boolean;
    workingno integer;
    timetype integer;
    timeoffset double precision;
    stimeoffset double precision;
    checktime timestamp without time zone;
    timeutc character varying;
    dateutc character varying;
    datetimeutc timestamp without time zone;
    datetimeutcfloat double precision;
    endtimeworkingdayfloat double precision;
    workingtime_cursor cursor;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN















	-- Get datetime Utc





	SET DateTimeUTC = GETUTCDATE()

	SET DateTimeUTCFloat = cast(DateTimeUTC AS FLOAT)
	SET DateTimeUTCFloat = DateTimeUTCFloat - FLOOR(DateTimeUTCFloat)

	SET TimeUTC = REPLACE(public."ConvertWorkingTimeWorkToTime"(DateTimeUTCFloat),':','')

	--- end get datetime utc


	SET EndTimeWorkingDay = (SELECT SettingValue FROM public."WorkingTime_Settings" where SettingNo = 2) || '00'
	SET DEndTimeWorkingDay = LEFT(EndTimeWorkingDay,2) || ':' || SUBSTRING(EndTimeWorkingDay,3,2) || ':' || RIGHT(EndTimeWorkingDay,2)
	SET EndTimeWorkingDayFloat = cast(DEndTimeWorkingDay AS FLOAT)

	SET CheckLunchStatus = CAST((SELECT SettingValue FROM public."WorkingTime_Settings" where SettingNo = 6) AS BIT)

	SET CheckInStatus =  0
	SET CheckOutStatus =  0
	SET Workingtime = 0
	SET WorkingTime_Cursor = CURSOR FAST_FORWARD
	FOR
		SELECT WorkingNo, CheckTime, TimeType, TimeOffset
		FROM WorkingTime_Get_WorkingTime_Times(UserNo, WorkingDay)
		ORDER BY WorkingNo

	OPEN WorkingTime_Cursor

	FETCH NEXT FROM WorkingTime_Cursor

	INTO WorkingNo, CheckTime, TimeType, TimeOffset

	WHILE @FETCH_STATUS = 0
	   BEGIN
			IF CheckLunchStatus = 0
				BEGIN
					IF TimeType = 1 AND CheckInStatus = 0   -- Check in 
						BEGIN 
						   SET sTimeOffset = TimeOffset
						   SET StartTimeWork = (public."ConverToUtcTime"(TimeOffset, CheckTime))
						   SET EndTimeWork = ''
						   SET CheckInStatus = 1
						   SET CheckOutStatus = 0
						END
					--ELSE IF TimeType = 1 AND CheckInStatus = 1 AND CheckOutStatus = 0  --  Check in multiple times
					--	BEGIN
					--	   SET sTimeOffset = TimeOffset
					--	   SET StartTimeWork = CheckTime
					--	END
					ELSE IF TimeType = 3 AND CheckInStatus = 1 -- Check Out times
						BEGIN 
						   SET EndTimeWork = (public."ConverToUtcTime"(TimeOffset, CheckTime))
						   SET CheckInStatus = 0
						   SET CheckOutStatus = 1
						   SET Workingtime =  Workingtime || (public."WorkingTimeWorks"(StartTimeWork, EndTimeWork))
						END
					ELSE IF TimeType = 3 AND CheckInStatus = 0 AND CheckOutStatus = 1 -- Check Out multiple times
						BEGIN 
						   SET StartTimeWork = EndTimeWork
						   SET EndTimeWork = (public."ConverToUtcTime"(TimeOffset, CheckTime))
						   SET Workingtime =  Workingtime || (public."WorkingTimeWorks"(StartTimeWork, EndTimeWork))
						END
					
				END
			ELSE IF CheckLunchStatus = 1
				BEGIN
					IF TimeType = 1 AND CheckInStatus = 0   -- Check in 
						BEGIN
						   SET sTimeOffset = TimeOffset
						   SET StartTimeWork = (public."ConverToUtcTime"(TimeOffset,(public."WorkingTimeWorks_CheckIn_Lunch"(CheckTime, TimeType))))
						   SET EndTimeWork = ''
						   SET CheckInStatus = 1
						   SET CheckOutStatus = 0
						END
					--ELSE IF TimeType = 1 AND CheckInStatus = 1 AND CheckOutStatus = 0  --  Check in multiple times
					--	BEGIN 
					--	    SET sTimeOffset = TimeOffset
					--		SET StartTimeWork = public."WorkingTimeWorks_CheckIn_Lunch"(CheckTime, TimeType) 
					--	END
					ELSE IF TimeType = 3 AND CheckInStatus = 1 -- Check Out times
						BEGIN 
							
						   SET EndTimeWork = (public."ConverToUtcTime"(TimeOffset,(public."WorkingTimeWorks_CheckIn_Lunch"(CheckTime, TimeType))))
						   SET CheckInStatus = 0
						   SET CheckOutStatus = 1
						   SET Workingtime =  Workingtime || (public."WorkingTimeWorksAddLunch"(StartTimeWork, EndTimeWork, TimeOffset))
						END
					ELSE IF TimeType = 3 AND CheckInStatus = 0 AND CheckOutStatus = 1 -- Check Out multiple times
						BEGIN
						   SET StartTimeWork = EndTimeWork 
						   SET EndTimeWork =(public."ConverToUtcTime"(TimeOffset, (public."WorkingTimeWorks_CheckIn_Lunch"(CheckTime, TimeType))))
						   SET Workingtime =  Workingtime || (public."WorkingTimeWorksAddLunch"(StartTimeWork, EndTimeWork, TimeOffset))
						END
				END
		  FETCH NEXT FROM WorkingTime_Cursor
		  INTO WorkingNo, CheckTime, TimeType, TimeOffset
	   END;
	CLOSE WorkingTime_Cursor
	DEALLOCATE WorkingTime_Cursor

	SET DateUTC =  CONVERT (VARCHAR (20), DATEADD(hour, sTimeOffset, DateTimeUTC), 112)

	IF DateUTC = WorkingDay
		BEGIN
			IF CheckLunchStatus = 0
				BEGIN 
					IF CheckInStatus = 1 AND CheckOutStatus = 0
						BEGIN
							IF EndTimeWorkingDayFloat <= DateTimeUTCFloat
								BEGIN
									SET EndTimeWork = (public."ConverToUtcTime"(TimeOffset,public."AddWorkingDayTimes"(TimeOffset, WorkingDay, EndTimeWorkingDay)))
								END
							ELSE
								BEGIN
									SET EndTimeWork =(public."ConverToUtcTime"(TimeOffset, (public."WorkingTimeWorks_CheckIn_Lunch"(public."AddWorkingDayTimes"(TimeOffset, WorkingDay ,TimeUTC), 3))))
								END
							SET Workingtime =  Workingtime || (public."WorkingTimeWorks"(StartTimeWork, EndTimeWork))
						END
				END
			ELSE IF CheckLunchStatus = 1
				BEGIN
					IF CheckInStatus = 1 AND CheckOutStatus = 0
						BEGIN
							IF EndTimeWorkingDayFloat <= DateTimeUTCFloat
								BEGIN
									SET EndTimeWork = (public."ConverToUtcTime"(TimeOffset,public."AddWorkingDayTimes"(TimeOffset, WorkingDay, EndTimeWorkingDay)))
								END
							ELSE
								BEGIN
									SET EndTimeWork = (public."ConverToUtcTime"(TimeOffset,(public."WorkingTimeWorks_CheckIn_Lunch"(public."AddWorkingDayTimes"(TimeOffset, WorkingDay, TimeUTC), 3))))
								END
								
							SET Workingtime =  Workingtime || (public."WorkingTimeWorksAddLunch"(StartTimeWork, EndTimeWork, TimeOffset))
						END
				END
		END
	ELSE  IF DateUTC > WorkingDay
		BEGIN
			IF CheckLunchStatus = 0
				BEGIN
					IF CheckInStatus = 1 AND CheckOutStatus = 0
					BEGIN
						SET EndTimeWork =  (public."ConverToUtcTime"(TimeOffset,DATEADD(day, (WorkingDay::date - 0::date),  CONVERT(CHAR(8), LEFT(EndTimeWorkingDay,2) || ':' || SUBSTRING(EndTimeWorkingDay,3,2) || ':' || RIGHT(EndTimeWorkingDay,2)))))
						SET Workingtime =  Workingtime || (public."WorkingTimeWorks"(StartTimeWork, EndTimeWork))
					END
				END
			ELSE IF CheckLunchStatus = 1
				BEGIN
				IF CheckInStatus = 1 AND CheckOutStatus = 0
					BEGIN
						SET EndTimeWork =  (public."ConverToUtcTime"(TimeOffset,DATEADD(day, (WorkingDay::date - 0::date),  CONVERT(CHAR(8), LEFT(EndTimeWorkingDay,2) || ':' || SUBSTRING(EndTimeWorkingDay,3,2) || ':' || RIGHT(EndTimeWorkingDay,2)))))
						SET Workingtime =  Workingtime || (public."WorkingTimeWorksAddLunch"(StartTimeWork, EndTimeWork, TimeOffset))
					END
				END
		END
	  SET RESULT = public."ConvertWorkingTimeWorkToTime"(Workingtime)

	  RETURN RESULT;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
