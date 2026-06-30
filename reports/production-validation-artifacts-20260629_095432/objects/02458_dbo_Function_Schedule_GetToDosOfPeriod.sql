-- ─── FUNCTION: schedule_gettodosofperiod ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_gettodosofperiod(integer, date, date);
CREATE OR REPLACE FUNCTION public.schedule_gettodosofperiod(
    userno integer,
    startdate date,
    enddate date
) RETURNS TABLE(
    departno text
)
AS $function$
DECLARE
    departnos table (
		departno int
	);
    departno integer;
BEGIN

	


	SELECT DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_gettodosofperiod.userno;
	INSERT INTO DepartNos VALUES(DepartNo)

	WHILE 1 = 1 BEGIN

		SELECT DepartNo = ParentNo FROM Organization_Departments WHERE DepartNo = DepartNo
		
		IF (DepartNo = 0) BEGIN
			BREAK	
		END
		
		INSERT INTO DepartNos VALUES(DepartNo)
		
	END
	
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
