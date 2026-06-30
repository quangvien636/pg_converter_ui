-- ─── FUNCTION: schedule_getddaysofperiod ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getddaysofperiod(integer, date, date);
CREATE OR REPLACE FUNCTION public.schedule_getddaysofperiod(
    userno integer,
    startdate date,
    enddate date
) RETURNS TABLE(
    belongno bigserial,
    userno integer,
    departno integer,
    positionno integer,
    dutyno integer,
    isdefault boolean
)
AS $function$
DECLARE
    departnos table (
		departno int
	);
    departno integer;
BEGIN

	


	SELECT DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getddaysofperiod.userno;
	INSERT INTO DepartNos VALUES(DepartNo)

	WHILE 1 = 1 BEGIN

		SELECT DepartNo = ParentNo FROM Organization_Departments WHERE DepartNo = DepartNo
		
		IF (DepartNo = 0) BEGIN
			BREAK	
		END
		
		INSERT INTO DepartNos VALUES(DepartNo)
		
	END
	
	RETURN QUERY
	SELECT 
		DdayNo, Title, Contents, DoomDate, IsLunar, IsHoliday, IsFiveWeek, IsLastDay, PeriodYear, 
		RegUserNo, public."COMNGetUserName"(RegUserNo) AS RegUserName,
		DisplayType, IsComplete, CompleteDate,
		CASE WHEN (
			SELECT COUNT(TagImageNo) 
			FROM ScheduleDdaysTag 
			WHERE UserNo = schedule_getddaysofperiod.userno AND GroupNo = D.GroupNo) = 0 THEN 
				COALESCE((
					SELECT TagImageNo 
					FROM ScheduleDdaysTag
					WHERE UserNo = D.RegUserNo
					AND GroupNo = D.GroupNo
				 ),0)
			ELSE
				(
					SELECT TagImageNo 
					FROM ScheduleDdaysTag
					WHERE UserNo = schedule_getddaysofperiod.userno
					AND GroupNo = D.GroupNo
				)  
		END AS TagImageNo    
	FROM ScheduleDdays D
	WHERE 
		D.DdayNo IN (
		SELECT DdayNo
		FROM ScheduleDdays
		WHERE RegUserNo = schedule_getddaysofperiod.userno AND
			DoomDate >= schedule_getddaysofperiod.startdate AND DoomDate <= schedule_getddaysofperiod.enddate
		)	
		OR D.DdayNo IN (
			SELECT DdayNo
			FROM ScheduleDdaySharers SDS
			WHERE (SDS.UserNo = schedule_getddaysofperiod.userno OR SDS.DepartNo IN (SELECT * FROM DepartNos))
			AND DoomDate >= schedule_getddaysofperiod.startdate AND DoomDate <= schedule_getddaysofperiod.enddate 
			);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
