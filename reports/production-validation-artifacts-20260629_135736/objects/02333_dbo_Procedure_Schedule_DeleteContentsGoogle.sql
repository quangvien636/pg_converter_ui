-- ─── PROCEDURE→FUNCTION: schedule_deletecontentsgoogle ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.schedule_deletecontentsgoogle(date, date, integer, character varying);
CREATE OR REPLACE FUNCTION public.schedule_deletecontentsgoogle(
    IN startdate date DEFAULT '1900-01-01',
    IN enddate date DEFAULT '1900-01-01',
    IN calendarno integer DEFAULT 0,
    IN googleentryidlist character varying DEFAULT ''
) RETURNS SETOF record
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
	)




	CheckEntryID := REPLACE(GoogleEntryIDList,',','');
	IF LEN(CheckEntryID) > 0 -- 값이 존재하는지 체크 THEN
		

		TempEntryIDList := schedule_deletecontentsgoogle.googleentryidlist || ',';
		WHILE STRPOS(',TempEntryIDList, ') > 0 LOOP

			TempEntryID := SUBSTRING(TempEntryIDList,0,STRPOS(',TempEntryIDList, '));;
			INSERT INTO GoogleEntryList
			(
				EntryID
			)
			VALUES
			(
				TempEntryID
			)
			
			TempEntryIDList := SUBSTRING(TempEntryIDList,STRPOS(',TempEntryIDList, ')+1,LEN(TempEntryIDList));
		END LOOP;
	END IF;
	SELECT COUNT(EntryID) INTO entrycount FROM GoogleEntryList
	
	IF EntryCount > 0 THEN
		IF StartDate = '1900-01-01' AND EndDate = '1900-01-01' -- 날짜가 지정되어 있지 않은 경우 THEN
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
		END IF;
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
			
		END;
		SELECT COUNT(ScheduleNo) INTO schdcount FROM ScheduleNoList
		
		IF SchdCount > 0 THEN
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
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
