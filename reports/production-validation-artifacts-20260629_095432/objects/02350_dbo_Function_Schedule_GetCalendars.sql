-- ─── FUNCTION: schedule_getcalendars ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getcalendars(integer);
CREATE OR REPLACE FUNCTION public.schedule_getcalendars(
    userno integer
) RETURNS TABLE(
    cano text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    positionnos table (
		positionno int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF (SELECT COUNT(*) FROM ScheduleCalendars
		WHERE IsFixed = TRUE AND RegUserNo = schedule_getcalendars.userno) = 0 BEGIN
	
		INSERT INTO ScheduleCalendars (
			RegUserNo, RegDate, ModUserNo, ModDate, Name, Type, Color, UseLevel, Description,
			IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, IsFixed, SortOrder)
		VALUES (UserNo, NOW(), UserNo, NOW(), '내 일정', 2, 'e55e76', 0, '',
			0, 0, 0, 0, 0, 1, 0)
		
		
	END
	IF (SELECT COUNT(UserNo) FROM ScheduleCalendarSetup WHERE UserNo = schedule_getcalendars.userno) > 0
		BEGIN;
			UPDATE ScheduleCalendarSetup
			SET
				DefaultCalendarNo = (SELECT /* TOP 1 */ CalendarNo FROM ScheduleCalendars WHERE RegUserNo = schedule_getcalendars.userno AND IsFixed = TRUE) --2023 
			WHERE UserNo = schedule_getcalendars.userno
			AND DefaultCalendarNo = 0
	END
	ELSE
	BEGIN

		SET CalNo  = (select /* TOP 1 */ CalendarNo FROM ScheduleCalendars WHERE RegUserNo = schedule_getcalendars.userno AND IsFixed = TRUE) --2023 

		INSERT INTO ScheduleCalendarSetup
		(UserNo, CalendarViewType, StartWeek, DefaultCalendarNo, DivisionUseYN, 
		RegUserNo, RegDate, ModUserNo, ModDate, IsFunctionComplete)
		VALUES
		(UserNo, 1, 0, CalNo, 'Y',
		UserNo, NOW(), UserNo, NOW(), 0)
	END


		DepartNo INT
	);

	with name_tree as 
	(
 		SELECT DepartNo, ParentNo FROM Organization_Departments 
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment 
			WHERE UserNo = schedule_getcalendars.userno
		)
	   union all
	   select C.DepartNo, C.ParentNo
	   from Organization_Departments c
	   join name_tree p on C.DepartNo = P.ParentNo  
		AND C.DepartNo<>C.ParentNo 
	) ;
	insert into DepartNos
	RETURN QUERY
	select DepartNo from name_tree
	-- 직급별

	INSERT INTO PositionNos
	RETURN QUERY
	SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getcalendars.userno


		CaNo INT
	);;
	insert into CaNo
	RETURN QUERY
	SELECT * FROM(
		SELECT CalendarNo FROM ScheduleCalendarPermisions 
		WHERE UserNo = schedule_getcalendars.userno OR DepartNo IN (SELECT DepartNo FROM DepartNos )
		UNION 
		SELECT CalendarNo FROM ScheduleCalendarSharers 
		WHERE  DepartNo IN (SELECT * FROM DepartNos)
		OR PositionNo IN (SELECT * FROM PositionNos)
		OR UserNo = schedule_getcalendars.userno
	)X

	RETURN QUERY
	SELECT CalendarNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, Type, Color, UseLevel, Description,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, IsFixed, SortOrder, CASE WHEN RegUserNo = schedule_getcalendars.userno THEN 'Y' ELSE '' END AS IsModYN
		, COALESCE(isDetail,0) isDetail
		, COALESCE(Detail,'') Detail
	FROM ScheduleCalendars
	WHERE Type <> 5 
	AND (RegUserNo = schedule_getcalendars.userno 
		OR isall = TRUE   ----20230913
		OR CalendarNo IN (SELECT  CaNo FROM CaNo )
	)
	UNION ALL
	RETURN QUERY
	SELECT CalendarNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, Type, Color, UseLevel, Description,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, IsFixed, SortOrder, CASE WHEN RegUserNo = schedule_getcalendars.userno THEN 'Y' ELSE '' END AS IsModYN
		, COALESCE(isDetail,0) isDetail
		, COALESCE(Detail,'') Detail
	FROM ScheduleCalendars
	WHERE Type = 5 AND (RegUserNo = schedule_getcalendars.userno OR CalendarNo IN  (SELECT  CaNo FROM CaNo ))
	ORDER BY Type, IsFixed DESC, SortOrder;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
