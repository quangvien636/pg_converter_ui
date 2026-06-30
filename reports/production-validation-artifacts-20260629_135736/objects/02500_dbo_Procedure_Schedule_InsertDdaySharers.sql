-- ─── PROCEDURE→FUNCTION: schedule_insertddaysharers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertddaysharers(character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertddaysharers(
    IN userid character varying DEFAULT '',
    IN departno integer DEFAULT 0,
    IN positionno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	IF DepartNo = 0 AND PositionNo = 0 -- 사용자 개별 THEN;
		INSERT INTO ScheduleDdaySharers(DdayNo, UserNo, DepartNo, PositionNo)
		VALUES (DdayNo, (SELECT UserNo FROM Organization_Users WHERE UserID = schedule_insertddaysharers.userid), 0, 0)
	END IF;
	ELSIF DepartNo > 0 AND PositionNo = 0 -- 부서별 THEN;
		INSERT INTO ScheduleDdaySharers(DdayNo, UserNo, DepartNo, PositionNo)
		VALUES (DdayNo, 0, DepartNo, 0)
	END IF;
	ELSIF DepartNo = 0 AND PositionNo > 0 -- 직급별 THEN;
		INSERT INTO ScheduleDdaySharers(DdayNo, UserNo, DepartNo, PositionNo)
		VALUES (DdayNo, 0, 0, PositionNo)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
