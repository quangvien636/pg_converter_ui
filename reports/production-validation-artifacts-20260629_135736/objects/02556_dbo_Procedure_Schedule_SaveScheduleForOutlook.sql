-- ─── PROCEDURE→FUNCTION: schedule_savescheduleforoutlook ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_savescheduleforoutlook(character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.schedule_savescheduleforoutlook(
    IN outlookentryid character varying,
    IN calendarentryid character varying,
    IN title character varying,
    IN content character varying,
    IN startdate timestamp without time zone,
    IN enddate timestamp without time zone,
    IN isallday boolean
) RETURNS SETOF record
AS $function$
DECLARE
    calendarno integer;
    outlookentrycnt integer;
    scheduleno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	-- 같은 스케쥴이 있는지 판단
	SELECT  INTO  FROM ScheduleContentsOutlook
	WHERE UserNo = UserNo
	AND OutlookEntryID = schedule_savescheduleforoutlook.outlookentryid
	
	-- 같은 스케쥴이 없으면 추가 작업
	IF OutlookEntryCnt = 0 THEN
		-- 캘린더 번호 구하기 (아웃룩)
		SELECT  INTO  FROM ScheduleCalendarsOutlook
		WHERE UserNo = UserNo
		AND OutlookEntryID = schedule_savescheduleforoutlook.calendarentryid
		
		INSERT INTO ScheduleContents
           (RegUserNo
           ,RegDate
           ,ModUserNo
           ,ModDate
           ,Title
           ,CalendarNo
           ,DivisionNo
           ,Content
           ,RepeatType
           ,RepeatCount
           ,RepeatMonth
           ,RepeatWeek
           ,RepeatDay
           ,RepeatDOWs
           ,StartDate
           ,EndDate
           ,StartTime
           ,EndTime
           ,IsAllDay
           ,IsNotiNote
           ,IsNotiMail
           ,IsNotiSMS
           ,IsNotiPopup
           ,NotiTimeType,
           Place)
     VALUES
           (UserNo
           ,NOW()
           ,UserNo
           ,NOW()
           ,Title
           ,CalendarNo
           ,1	--업무 구분
           ,Content
           ,0		--반복타입
           ,0	--반복카운트
           ,0	--반복월
           ,0		--반복주
           ,0		--반복일
           ,0		--반복요일
           ,CONVERT(DATE,StartDate)
           ,CONVERT(DATE,EndDate)
           ,CONVERT(TIME,StartDate)
           ,CONVERT(TIME,EndDate)
           ,IsAllDay		-- 종일여부
           ,0	-- 알림쪽지
           ,0	-- 알림메일
           ,0   -- 알림SMS 
           ,0   -- 알림팝업
           ,1
           ,Place)
		ScheduleNo := lastval();
		-- 아웃룩 일정 연동정보 저장;
		INSERT INTO ScheduleContentsOutlook
		(
			UserNo,
			ScheduleNo,
			OutlookEntryID
		)
		VALUES
		(
			UserNo,
			ScheduleNo,
			OutlookEntryID
		)
	END IF;
	ELSE -- 일정정보가 존재하면 업데이트
	BEGIN
		SELECT  INTO  FROM ScheduleContentsOutlook
		WHERE OutlookEntryID = schedule_savescheduleforoutlook.outlookentryid
		-- 일정 내용 업데이트 처리;
		UPDATE ScheduleContents
		CalendarNo := CalendarNo,;
			Title = schedule_savescheduleforoutlook.title,
			Content = schedule_savescheduleforoutlook.content,
			StartDate = CONVERT(DATE,StartDate),
			StartTime = CONVERT(TIME,StartDate),
			EndDate = CONVERT(DATE,EndDate),
			EndTime = CONVERT(TIME,EndDate),
			Place = Place,
			ModUserNo = UserNo,
			ModDate = NOW()
		WHERE ScheduleNo = ScheduleNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
