-- ─── PROCEDURE→FUNCTION: schedule_getschedulesforoutlook ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getschedulesforoutlook(integer, date, date);
CREATE OR REPLACE FUNCTION public.schedule_getschedulesforoutlook(
    IN userno integer,
    IN startdate date,
    IN enddate date
) RETURNS SETOF record
AS $function$
DECLARE
    departnos table (
		departno int
	);
    departno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	SELECT DepartNo INTO departno FROM Organization_BelongToDepartment WHERE UserNo = schedule_getschedulesforoutlook.userno;
	INSERT INTO DepartNos VALUES(DepartNo)

	WHILE 1 = 1 LOOP

		SELECT ParentNo INTO departno FROM Organization_Departments WHERE DepartNo = DepartNo
		
		IF DepartNo = 0 THEN
			EXIT;
		END IF;
		
		INSERT INTO DepartNos VALUES(DepartNo)
		
	END LOOP;

	RETURN QUERY
	SELECT SO.OutlookEntryID, CO.OutlookEntryID AS CalendarEntryID,
		S.ScheduleNo, Title, Content, S.CalendarNo, DivisionNo,
		RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
		StartDate, EndDate, StartTime, EndTime, IsAllDay,
		S.IsNotiNote, S.IsNotiMail, S.IsNotiSMS, S.IsNotiPopup, S.NotiTimeType,
		CASE WHEN RegUserNo = schedule_getschedulesforoutlook.userno THEN 'Y' ELSE '' END ModYN,
		CASE WHEN CONVERT(VARCHAR(8),StartDate,112) < CONVERT(VARCHAR(8),NOW(),112) THEN 'Y' ELSE '' END LastYN
	FROM ScheduleContents S
	LEFT JOIN ScheduleContentsOutlook SO ON S.ScheduleNo = SO.ScheduleNo
	LEFT JOIN ScheduleCalendarsOutlook CO ON S.CalendarNo = CO.CalendarNo
	WHERE S.CalendarNo IN (
		SELECT CalendarNo FROM ScheduleCalendars
		WHERE RegUserNo = schedule_getschedulesforoutlook.userno OR Type = 1 OR CalendarNo IN (
			SELECT CalendarNo FROM ScheduleCalendarSharers
			WHERE UserNo = schedule_getschedulesforoutlook.userno OR DepartNo IN (SELECT * FROM DepartNos)
			)
		)
		OR S.ScheduleNo IN (
			SELECT ScheduleNo FROM ScheduleContentSharers
			WHERE UserNo = schedule_getschedulesforoutlook.userno OR DepartNo IN (SELECT * FROM DepartNos)
		)
		
		/*AND (
			StartDate BETWEEN StartDate AND EndDate
			OR EndDate BETWEEN StartDate AND EndDate
		)*/
	ORDER BY StartDate, IsAllDay, StartTime;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
