-- ─── PROCEDURE→FUNCTION: schedule_getddaysofperiod ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getddaysofperiod(integer, date, date);
CREATE OR REPLACE FUNCTION public.schedule_getddaysofperiod(
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

	


	SELECT DepartNo INTO departno FROM Organization_BelongToDepartment WHERE UserNo = schedule_getddaysofperiod.userno;
	INSERT INTO DepartNos VALUES(DepartNo)

	WHILE 1 = 1 LOOP

		SELECT ParentNo INTO departno FROM Organization_Departments WHERE DepartNo = DepartNo
		
		IF DepartNo = 0 THEN
			EXIT;
		END IF;
		
		INSERT INTO DepartNos VALUES(DepartNo)
		
	END LOOP;
	
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
