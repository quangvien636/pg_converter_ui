-- ─── FUNCTION: schedule_gettodocounts ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_gettodocounts(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_gettodocounts(
    userno integer,
    groupno integer,
    iscomplete integer DEFAULT 1
) RETURNS TABLE(
    col1 text
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

	


	SELECT DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_gettodocounts.userno

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
	SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_gettodocounts.userno
	
	IF GroupNo = -1 BEGIN

		RETURN QUERY
		SELECT COUNT(*)
		FROM ScheduleToDos S
		LEFT JOIN ScheduleToDoGroups DG ON DG.GroupNo = S.GroupNo
		WHERE (S.RegUserNo = schedule_gettodocounts.userno
			OR S.ToDoNo IN (
						SELECT ToDoNo
						FROM ScheduleToDoSharers STS
						WHERE STS.UserNo = schedule_gettodocounts.userno 
						OR STS.DepartNo IN (SELECT DepartNo FROM DepartNos)
						OR STS.PositionNo IN (SELECT PositionNo FROM PositionNos)
					))
		AND (1 = schedule_gettodocounts.iscomplete OR IsComplete = schedule_gettodocounts.iscomplete)
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT COUNT(*)
		FROM ScheduleToDos S
		LEFT JOIN ScheduleToDoGroups DG ON DG.GroupNo = S.GroupNo
		WHERE S.RegUserNo = schedule_gettodocounts.userno AND S.GroupNo = schedule_gettodocounts.groupno
		AND (1 = schedule_gettodocounts.iscomplete OR IsComplete = schedule_gettodocounts.iscomplete)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
