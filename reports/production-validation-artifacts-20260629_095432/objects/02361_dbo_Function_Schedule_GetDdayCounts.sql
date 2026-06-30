-- ─── FUNCTION: schedule_getddaycounts ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getddaycounts(integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.schedule_getddaycounts(
    userno integer,
    groupno integer,
    isshare boolean DEFAULT TRUE
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



	SELECT DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getddaycounts.userno;
	INSERT INTO DepartNos VALUES(DepartNo)

	WHILE 1 = 1 BEGIN

		SELECT DepartNo = ParentNo FROM Organization_Departments WHERE DepartNo = DepartNo
		
		IF (DepartNo = 0) BEGIN
			BREAK	
		END
		
		INSERT INTO DepartNos VALUES(DepartNo)
		
	END
	
	-- 직급별

	INSERT INTO PositionNos
	RETURN QUERY
	SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getddaycounts.userno
	
	IF GroupNo = -1 BEGIN

		IF IsShare = TRUE
		BEGIN
		
			RETURN QUERY
			SELECT COUNT(*)
			FROM ScheduleDdays S
			LEFT JOIN ScheduleDdayGroups DG ON DG.GroupNo = S.GroupNo
			WHERE S.RegUserNo = schedule_getddaycounts.userno
			OR S.DdayNo IN (
								SELECT DdayNo
								FROM ScheduleDdaySharers SDS
								WHERE (
								SDS.UserNo = schedule_getddaycounts.userno 
								OR SDS.DepartNo IN (SELECT * FROM DepartNos)
								OR SDS.PositionNo IN (SELECT * FROM PositionNos)
								)
							)
		END
		ELSE
		BEGIN
			RETURN QUERY
			SELECT COUNT(*)
			FROM ScheduleDdays S
			LEFT JOIN ScheduleDdayGroups DG ON DG.GroupNo = S.GroupNo
			WHERE S.RegUserNo = schedule_getddaycounts.userno
		END
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT COUNT(*)
		FROM ScheduleDdays S
		LEFT JOIN ScheduleDdayGroups DG ON DG.GroupNo = S.GroupNo
		WHERE S.RegUserNo = schedule_getddaycounts.userno AND S.GroupNo = schedule_getddaycounts.groupno
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
