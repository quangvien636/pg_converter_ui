-- ─── FUNCTION: schedule_getddaysofrepeat ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getddaysofrepeat();
CREATE OR REPLACE FUNCTION public.schedule_getddaysofrepeat(
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
    positionnos table (
		positionno int
	);
BEGIN



	SELECT DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo;
	INSERT INTO DepartNos VALUES(DepartNo)

	WHILE 1 = 1 BEGIN
		SELECT DepartNo = ParentNo FROM Organization_Departments WHERE DepartNo = DepartNo
		IF (DepartNo = 0) BEGIN
			BREAK	
		END;
		INSERT INTO DepartNos VALUES(DepartNo)
	END
	-- 직급별

	INSERT INTO PositionNos
	RETURN QUERY
	SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo
			
	RETURN QUERY
	SELECT 
		D.DdayNo, Title, Contents, 
		COALESCE(R.RepeatDate,D.DoomDate) As DoomDate, IsLunar, IsHoliday, IsFiveWeek, IsLastDay, 
		PeriodYear, RegUserNo, public."COMNGetUserName"(RegUserNo) AS RegUserName, RegDate, 
		ModUserNo, ModDate, GroupNo,
		RepeatEndDate, RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, 
		DisplayType,
		COALESCE(R.IsComplete,D.IsComplete) As IsComplete, 
		COALESCE(R.CompleteDate, D.CompleteDate) As CompleteDate,
		CASE WHEN (
			SELECT COUNT(TagImageNo) 
			FROM ScheduleDdaysTag 
			WHERE UserNo = UserNo AND GroupNo = D.GroupNo) = 0 THEN 
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
					WHERE UserNo = UserNo
					AND GroupNo = D.GroupNo
				)  
		END AS TagImageNo
	FROM ScheduleDdays D
	LEFT JOIN ScheduleDdaysRepeat R ON D.DdayNo = R.DdayNo
	WHERE 
		D.DdayNo IN (
		SELECT DdayNo
		FROM ScheduleDdays
		WHERE RegUserNo = UserNo
		)	
		OR D.DdayNo IN (
			SELECT DdayNo
			FROM ScheduleDdaySharers SDS
			WHERE (SDS.UserNo = UserNo 
			OR SDS.DepartNo IN (SELECT * FROM DepartNos)
			OR SDS.PositionNo IN (SELECT * FROM PositionNos)
			)
		);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
