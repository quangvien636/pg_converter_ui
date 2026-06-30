-- ─── PROCEDURE→FUNCTION: schedule_gettodos ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_gettodos(integer, integer, integer, integer, boolean, boolean);
CREATE OR REPLACE FUNCTION public.schedule_gettodos(
    IN userno integer,
    IN groupno integer,
    IN viewcount integer,
    IN currentpageindex integer,
    IN isshare boolean DEFAULT FALSE,
    IN iscomplete boolean DEFAULT TRUE
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



	SELECT DepartNo INTO departno FROM Organization_BelongToDepartment WHERE UserNo = schedule_gettodos.userno

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
	SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_gettodos.userno
	
	IF GroupNo = -1 THEN
		IF IsShare = FALSE THEN
			RETURN QUERY
			SELECT * FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY S.CompleteDate ASC) AS RowNum,
					ToDoNo, S.RegUserNo, S.RegDate, S.ModUserNo, S.ModDate,
					Title, S.GroupNo, DG.Name AS GroupName,
					Important, CompleteDate, IsComplete,
					IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, ProgressRate
				FROM ScheduleToDos S
				LEFT JOIN ScheduleToDoGroups DG ON DG.GroupNo = S.GroupNo
				--WHERE S.RegUserNo = UserNo
				WHERE 
					S.RegUserNo = schedule_gettodos.userno
				AND (1 = schedule_gettodos.iscomplete OR IsComplete = schedule_gettodos.iscomplete) 
			) AS T
			WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
		END IF;
		ELSE
			RETURN QUERY
			SELECT * FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY S.CompleteDate ASC) AS RowNum,
					ToDoNo, S.RegUserNo, S.RegDate, S.ModUserNo, S.ModDate,
					Title, S.GroupNo, DG.Name AS GroupName,
					Important, CompleteDate, IsComplete,
					IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, ProgressRate
				FROM ScheduleToDos S
				LEFT JOIN ScheduleToDoGroups DG ON DG.GroupNo = S.GroupNo
				--WHERE S.RegUserNo = UserNo
				WHERE 
					(S.RegUserNo = schedule_gettodos.userno
					OR S.ToDoNo IN (
						SELECT ToDoNo
						FROM ScheduleToDoSharers STS
						WHERE STS.UserNo = schedule_gettodos.userno 
						OR STS.DepartNo IN (SELECT DepartNo FROM DepartNos)
						OR STS.PositionNo IN (SELECT PositionNo FROM PositionNos)
					))
				AND (1 = schedule_gettodos.iscomplete OR IsComplete = schedule_gettodos.iscomplete) 
			) AS T
			WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
		END IF;
	END IF;
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT * FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY S.CompleteDate ASC) AS RowNum,
				ToDoNo, S.RegUserNo, S.RegDate, S.ModUserNo, S.ModDate,
				Title, S.GroupNo, DG.Name AS GroupName,
				Important, CompleteDate, IsComplete,
				IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, ProgressRate
			FROM ScheduleToDos S
			LEFT JOIN ScheduleToDoGroups DG ON DG.GroupNo = S.GroupNo
			WHERE S.RegUserNo = schedule_gettodos.userno AND S.GroupNo = schedule_gettodos.groupno
			AND (1 = schedule_gettodos.iscomplete OR IsComplete = schedule_gettodos.iscomplete) 
		) AS T
		WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
