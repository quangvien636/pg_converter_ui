-- ─── FUNCTION: schedule_insertddaysharers ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertddaysharers(character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertddaysharers(
    userid character varying DEFAULT '',
    departno integer DEFAULT 0,
    positionno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	IF DepartNo = 0 AND PositionNo = 0 -- 사용자 개별
	BEGIN;
		INSERT INTO ScheduleDdaySharers(DdayNo, UserNo, DepartNo, PositionNo)
		VALUES (DdayNo, (SELECT UserNo FROM Organization_Users WHERE UserID = schedule_insertddaysharers.userid), 0, 0)
	END
	ELSE IF DepartNo > 0 AND PositionNo = 0 -- 부서별
	BEGIN;
		INSERT INTO ScheduleDdaySharers(DdayNo, UserNo, DepartNo, PositionNo)
		VALUES (DdayNo, 0, DepartNo, 0)
	END
	ELSE IF DepartNo = 0 AND PositionNo > 0 -- 직급별
	BEGIN;
		INSERT INTO ScheduleDdaySharers(DdayNo, UserNo, DepartNo, PositionNo)
		VALUES (DdayNo, 0, 0, PositionNo)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
