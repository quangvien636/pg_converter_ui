-- ─── PROCEDURE→FUNCTION: schedule_gettodocounts ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_gettodocounts(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_gettodocounts(
    IN userno integer,
    IN groupno integer,
    IN iscomplete integer DEFAULT 1
) RETURNS SETOF record
AS $function$
DECLARE
    departnos table (
		departno int
	);
    departno integer;
    positionnos table (
		positionno int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	


	SELECT DepartNo INTO departno FROM Organization_BelongToDepartment WHERE UserNo = schedule_gettodocounts.userno

	IF DepartNo IS NOT NULL THEN

		INSERT INTO DepartNos VALUES(DepartNo)

		WHILE 1 = 1 LOOP

			SELECT ParentNo INTO departno FROM Organization_Departments WHERE DepartNo = DepartNo
		
			IF DepartNo = 0 THEN
				EXIT;
			END IF;
		
			INSERT INTO DepartNos VALUES(DepartNo)
		
		END LOOP;
	
	END IF;

	-- 직급별

	INSERT INTO PositionNos
	RETURN QUERY
	SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_gettodocounts.userno
	
	IF GroupNo = -1 THEN

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
	END IF;
	
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
