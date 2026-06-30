-- ─── FUNCTION: schedule_savescheduleforgoogle ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_savescheduleforgoogle(character varying, character varying, integer, character varying, character varying, date, date, time without time zone, time without time zone, boolean, integer, integer, integer, integer, integer, integer, boolean, boolean, integer);
CREATE OR REPLACE FUNCTION public.schedule_savescheduleforgoogle(
    googleentryid character varying,
    googleentryuri character varying,
    calendarno integer,
    title character varying,
    content character varying,
    startdate date,
    enddate date,
    starttime time without time zone,
    endtime time without time zone,
    isallday boolean DEFAULT FALSE,
    repeattype integer DEFAULT 0,
    repeatcount integer DEFAULT 0,
    repeatmonth integer DEFAULT 0,
    repeatweek integer DEFAULT 0,
    repeatday integer DEFAULT 0,
    repeatdows integer DEFAULT 0,
    isnotimail boolean DEFAULT FALSE,
    isnotipopup boolean DEFAULT FALSE,
    notitimetype integer DEFAULT 1
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    googleentrycnt integer;
    scheduleno integer;
BEGIN



	-- 같은 스케쥴이 있는지를 판단.
	SELECT GoogleEntryCnt = COUNT(ScheduleNo) 
	FROM ScheduleContentsGoogle
	WHERE UserNo = UserNo
	AND GoogleEntryID = schedule_savescheduleforgoogle.googleentryid
	
	-- 같은 스케쥴이 없으면 추가 작업
	IF GoogleEntryCnt = 0
	BEGIN;
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
           ,NotiTimeType)
     VALUES
           (UserNo
           ,NOW()
           ,UserNo
           ,NOW()
           ,Title
           ,CalendarNo
           ,1	--업무 구분
           ,Content
           ,RepeatType		--반복타입
           ,RepeatCount	--반복카운트
           ,RepeatMonth	--반복월
           ,RepeatWeek		--반복주
           ,RepeatDay		--반복일
           ,RepeatDOWs		--반복요일
           ,StartDate
           ,EndDate
           ,StartTime
           ,EndTime
           ,IsAllDay		-- 종일여부
           ,0	-- 알림쪽지
           ,IsNotiMail	-- 알림메일
           ,0   -- 알림SMS 
           ,IsNotiPopup   -- 알림팝업
           ,NotiTimeType)
		SET ScheduleNo = lastval()
		-- 구글 일정 연동정보 저장;
		INSERT INTO ScheduleContentsGoogle
		(
			UserNo,
			ScheduleNo,
			GoogleEntryID,
			GoogleEntryUri
		)
		VALUES
		(
			UserNo,
			ScheduleNo,
			GoogleEntryID,
			GoogleEntryUri
		)
	END
	ELSE -- 일정정보가 존재하면 업데이트
	BEGIN
		SELECT ScheduleNo = ScheduleNo
		FROM ScheduleContentsGoogle
		WHERE GoogleEntryID = schedule_savescheduleforgoogle.googleentryid
		-- 일정 내용 업데이트 처리;
		UPDATE ScheduleContents
		SET
			CalendarNo = schedule_savescheduleforgoogle.calendarno,
			Title = schedule_savescheduleforgoogle.title,
			Content = schedule_savescheduleforgoogle.content,
			StartDate = schedule_savescheduleforgoogle.startdate,
			StartTime = schedule_savescheduleforgoogle.starttime,
			EndDate = schedule_savescheduleforgoogle.enddate,
			EndTime = schedule_savescheduleforgoogle.endtime,
			ModUserNo = UserNo,
			ModDate = NOW(),
			RepeatType = schedule_savescheduleforgoogle.repeattype,
			RepeatCount = schedule_savescheduleforgoogle.repeatcount,
		    RepeatMonth = schedule_savescheduleforgoogle.repeatmonth,
		    RepeatWeek = schedule_savescheduleforgoogle.repeatweek,
		    RepeatDay = schedule_savescheduleforgoogle.repeatday,
		    RepeatDOWs = schedule_savescheduleforgoogle.repeatdows,
		    IsNotiMail = schedule_savescheduleforgoogle.isnotimail,
		    IsNotiPopup = schedule_savescheduleforgoogle.isnotipopup,
		    NotiTimeType = schedule_savescheduleforgoogle.notitimetype
		WHERE ScheduleNo = ScheduleNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
