-- ─── PROCEDURE→FUNCTION: workingtime_setworkingtimeworktime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_setworkingtimeworktime(integer, character varying, integer, integer, integer, integer, boolean, integer);
CREATE OR REPLACE FUNCTION public.workingtime_setworkingtimeworktime(
    IN worktimeno integer,
    IN title character varying,
    IN workstart integer,
    IN workend integer,
    IN lunchstart integer,
    IN lunchend integer,
    IN isaddlunch boolean,
    IN locationno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	IF WorkTimeNo=0 THEN;
			INSERT INTO WorkingTime_WorkTime (LocationNo,Title, WorkStart, WorkEnd, LunchStart, LunchEnd, IsAddLunch)
			VALUES (LocationNo,Title, WorkStart, WorkEnd, LunchStart, LunchEnd, IsAddLunch)
		END IF;
	ELSE;
			UPDATE WorkingTime_WorkTime
			Title := workingtime_setworkingtimeworktime.title,WorkStart=workingtime_setworkingtimeworktime.workstart,WorkEnd=workingtime_setworkingtimeworktime.workend,LunchStart=workingtime_setworkingtimeworktime.lunchstart,LunchEnd=workingtime_setworkingtimeworktime.lunchend,IsAddLunch=workingtime_setworkingtimeworktime.isaddlunch;
			WHERE WorkTimeNo=workingtime_setworkingtimeworktime.worktimeno
		END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
