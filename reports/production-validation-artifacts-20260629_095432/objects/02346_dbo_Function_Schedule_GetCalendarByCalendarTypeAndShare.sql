-- ─── FUNCTION: schedule_getcalendarbycalendartypeandshare ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getcalendarbycalendartypeandshare(integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_getcalendarbycalendartypeandshare(
    userno integer,
    calendartype integer
) RETURNS TABLE(
    calendarno serial,
    reguserno integer,
    regdate timestamp without time zone,
    moduserno integer,
    moddate timestamp without time zone,
    name character varying(100),
    type integer,
    color character(6),
    uselevel integer,
    description character varying(500),
    isnotinote boolean,
    isnotimail boolean,
    isnotisms boolean,
    isnotipopup boolean,
    notitimetype integer,
    isfixed boolean,
    sortorder double precision,
    isactive boolean,
    isall boolean,
    isdetail boolean,
    detail text
)
AS $function$
DECLARE
    departnos table (
		departno int
	);
    departno integer;
    positionnos table (
		positionno int
	);
BEGIN


	IF (SELECT COUNT(*) FROM ScheduleCalendars
		WHERE IsFixed = TRUE AND RegUserNo = schedule_getcalendarbycalendartypeandshare.userno) = 0 BEGIN
	
		INSERT INTO ScheduleCalendars (
			RegUserNo, RegDate, ModUserNo, ModDate, Name, Type, Color, UseLevel, Description,
			IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, IsFixed, SortOrder)
		VALUES (UserNo, NOW(), UserNo, NOW(), '내 일정', 2, 'e55e76', 0, '',
			0, 0, 0, 0, 0, 1, 0)
		
	END



	SELECT DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getcalendarbycalendartypeandshare.userno

	IF (DepartNo IS NOT NULL) BEGIN

		INSERT INTO DepartNos VALUES(DepartNo)
	
		WHILE 1 = 1 BEGIN
	
			SELECT DepartNo = ParentNo FROM Organization_Departments WHERE DepartNo = DepartNo
		
			IF (DepartNo = 0) BEGIN
				BREAK	
			END
		
			INSERT INTO DepartNos VALUES(DepartNo)
		
		END

	END

	-- 직급별

	INSERT INTO PositionNos
	RETURN QUERY
	SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getcalendarbycalendartypeandshare.userno

	RETURN QUERY
	SELECT CalendarNo	
	, Name, Type, Color
	
	, IsFixed, SortOrder, CASE WHEN RegUserNo = schedule_getcalendarbycalendartypeandshare.userno THEN 'Y' ELSE '' END AS IsModYN
	FROM ScheduleCalendars
	WHERE 1=1 
	--AND RegUserNo = UserNo 
	AND Type = schedule_getcalendarbycalendartypeandshare.calendartype 
	
	OR CalendarNo IN (
		SELECT CalendarNo FROM ScheduleCalendarSharers
		WHERE UserNo = schedule_getcalendarbycalendartypeandshare.userno 
		OR DepartNo IN (SELECT * FROM DepartNos)
		OR PositionNo IN (SELECT * FROM PositionNos)
	)
	ORDER BY IsFixed DESC, SortOrder;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
