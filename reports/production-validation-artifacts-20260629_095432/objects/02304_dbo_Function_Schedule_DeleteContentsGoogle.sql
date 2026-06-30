-- ─── FUNCTION: schedule_deletecontentsgoogle ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deletecontentsgoogle(date, date, integer, character varying);
CREATE OR REPLACE FUNCTION public.schedule_deletecontentsgoogle(
    startdate date DEFAULT '1900-01-01',
    enddate date DEFAULT '1900-01-01',
    calendarno integer DEFAULT 0,
    googleentryidlist character varying DEFAULT ''
) RETURNS TABLE(
    scheduleno text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    schedulenolist table(scheduleno int);
    checkentryid character varying;
    entrycount integer;
    schdcount integer;
    tempentryidlist character varying;
    tempentryid character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- 임시 테이블 생성





	SET CheckEntryID = REPLACE(GoogleEntryIDList,',','')
	
	IF LEN(CheckEntryID) > 0 -- 값이 존재하는지 체크
	BEGIN
		

		SET TempEntryIDList = schedule_deletecontentsgoogle.googleentryidlist || ','
		WHILE STRPOS(',TempEntryIDList, ') > 0
		BEGIN

			SET TempEntryID = SUBSTRING(TempEntryIDList,0,STRPOS(',TempEntryIDList, '))
			
			INSERT INTO GoogleEntryList
			(
				EntryID
			)
			VALUES
			(
				TempEntryID
			)
			
			SET TempEntryIDList = SUBSTRING(TempEntryIDList,STRPOS(',TempEntryIDList, ')+1,LEN(TempEntryIDList))	
		END
	END
	SELECT EntryCount = COUNT(EntryID) FROM GoogleEntryList
	
	IF EntryCount > 0
	BEGIN
		IF StartDate = '1900-01-01' AND EndDate = '1900-01-01' -- 날짜가 지정되어 있지 않은 경우
		BEGIN
					-- 삭제할 스케줄을 입력;
			INSERT INTO ScheduleNoList
			(
				ScheduleNo
			)
			RETURN QUERY
			SELECT
				SC.ScheduleNo
			FROM ScheduleContentsGoogle SCG
			INNER JOIN ScheduleContents SC ON SCG.ScheduleNo = SC.ScheduleNo
			WHERE SC.CalendarNo = schedule_deletecontentsgoogle.calendarno
			AND SC.RegUserNo = SCG.UserNo
			AND SCG.UserNo = UserNo
			AND SCG.GoogleEntryID NOT IN ( SELECT EntryID FROM GoogleEntryList)
		END
		ELSE -- 날짜가 제한되어 있는경우
		BEGIN
			-- 삭제할 스케줄을 입력;
			INSERT INTO ScheduleNoList
			(
				ScheduleNo
			)
			RETURN QUERY
			SELECT
				SC.ScheduleNo
			FROM ScheduleContentsGoogle SCG
			INNER JOIN ScheduleContents SC ON SCG.ScheduleNo = SC.ScheduleNo
			WHERE StartDate < schedule_deletecontentsgoogle.enddate
			AND EndDate > schedule_deletecontentsgoogle.startdate
			AND SC.CalendarNo = schedule_deletecontentsgoogle.calendarno
			AND SC.RegUserNo = SCG.UserNo
			AND SCG.UserNo = UserNo
			AND SCG.GoogleEntryID NOT IN ( SELECT EntryID FROM GoogleEntryList)
			
		END
		SELECT SchdCount = COUNT(ScheduleNo) FROM ScheduleNoList
		
		IF SchdCount > 0
		BEGIN
			-- 공유자를 삭제;
			DELETE FROM ScheduleContentSharers
			WHERE ScheduleNo IN
			(
				SELECT ScheduleNo FROM ScheduleNoList
			)
			-- 내용을 삭제 ;
			DELETE FROM ScheduleContents
			WHERE ScheduleNo IN
			(
				SELECT ScheduleNo FROM ScheduleNoList
			)
			-- 구글 공유정보를 삭제;
			DELETE FROM ScheduleContentsGoogle
			WHERE ScheduleNo IN
			(
				SELECT ScheduleNo FROM ScheduleNoList
			)
			AND UserNo = UserNo
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
