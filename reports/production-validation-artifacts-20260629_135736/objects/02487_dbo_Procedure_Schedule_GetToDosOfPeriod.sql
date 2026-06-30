-- ─── PROCEDURE→FUNCTION: schedule_gettodosofperiod ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_gettodosofperiod(integer, date, date);
CREATE OR REPLACE FUNCTION public.schedule_gettodosofperiod(
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

	


	SELECT DepartNo INTO departno FROM Organization_BelongToDepartment WHERE UserNo = schedule_gettodosofperiod.userno;
	INSERT INTO DepartNos VALUES(DepartNo)

	WHILE 1 = 1 LOOP

		SELECT ParentNo INTO departno FROM Organization_Departments WHERE DepartNo = DepartNo
		
		IF DepartNo = 0 THEN
			EXIT;
		END IF;
		
		INSERT INTO DepartNos VALUES(DepartNo)
		
	END LOOP;
	
	RETURN QUERY
	SELECT ToDoNo, Title, Important, CompleteDate, IsComplete, ProgressRate, 
	RegUserNo, public."COMNGetUserName"(RegUserNo) As RegUserName
	FROM ScheduleToDos T
	WHERE T.ToDoNo IN (
		SELECT ToDoNo
		FROM ScheduleToDos
		WHERE 
			RegUserNo = schedule_gettodosofperiod.userno AND
			CompleteDate >= schedule_gettodosofperiod.startdate AND CompleteDate <= schedule_gettodosofperiod.enddate
		)
		OR T.ToDoNo IN (
			SELECT ToDoNo
			FROM ScheduleToDoSharers STS
			WHERE (STS.UserNo = schedule_gettodosofperiod.userno OR STS.DepartNo IN (SELECT DepartNo FROM DepartNos))
			AND CompleteDate >= schedule_gettodosofperiod.startdate AND CompleteDate <= schedule_gettodosofperiod.enddate
		);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
