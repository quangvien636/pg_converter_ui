-- ─── FUNCTION: schedule_gettodos ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_gettodos(integer, integer, integer, integer, boolean, boolean);
CREATE OR REPLACE FUNCTION public.schedule_gettodos(
    userno integer,
    groupno integer,
    viewcount integer,
    currentpageindex integer,
    isshare boolean DEFAULT FALSE,
    iscomplete boolean DEFAULT TRUE
) RETURNS TABLE(
    rownum text,
    todono text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    title text,
    groupno text,
    groupname text,
    important text,
    completedate text,
    iscomplete text,
    isnotinote text,
    isnotimail text,
    isnotisms text,
    isnotipopup text,
    notitimetype text,
    progressrate text
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



	SELECT DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_gettodos.userno

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
	SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_gettodos.userno
	
	IF GroupNo = -1 BEGIN
		IF IsShare = FALSE
		BEGIN
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
		END
		ELSE
		BEGIN
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
		END
	END
	
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
