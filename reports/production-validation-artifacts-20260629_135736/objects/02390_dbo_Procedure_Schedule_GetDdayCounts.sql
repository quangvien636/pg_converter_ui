-- ─── PROCEDURE→FUNCTION: schedule_getddaycounts ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getddaycounts(integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.schedule_getddaycounts(
    IN userno integer,
    IN groupno integer,
    IN isshare boolean DEFAULT TRUE
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



	SELECT DepartNo INTO departno FROM Organization_BelongToDepartment WHERE UserNo = schedule_getddaycounts.userno;
	INSERT INTO DepartNos VALUES(DepartNo)

	WHILE 1 = 1 LOOP

		SELECT ParentNo INTO departno FROM Organization_Departments WHERE DepartNo = DepartNo
		
		IF DepartNo = 0 THEN
			EXIT;
		END IF;
		
		INSERT INTO DepartNos VALUES(DepartNo)
		
	END LOOP;
	
	-- 직급별

	INSERT INTO PositionNos
	RETURN QUERY
	SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getddaycounts.userno
	
	IF GroupNo = -1 THEN

		IF IsShare = TRUE THEN
		
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
		END IF;
		ELSE
			RETURN QUERY
			SELECT COUNT(*)
			FROM ScheduleDdays S
			LEFT JOIN ScheduleDdayGroups DG ON DG.GroupNo = S.GroupNo
			WHERE S.RegUserNo = schedule_getddaycounts.userno
		END IF;
	END IF;
	
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
