-- ─── FUNCTION: workingtime_setworkingtimeworktime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_setworkingtimeworktime(integer, character varying, integer, integer, integer, integer, boolean, integer);
CREATE OR REPLACE FUNCTION public.workingtime_setworkingtimeworktime(
    worktimeno integer,
    title character varying,
    workstart integer,
    workend integer,
    lunchstart integer,
    lunchend integer,
    isaddlunch boolean,
    locationno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	IF WorkTimeNo=0
		BEGIN;
			INSERT INTO WorkingTime_WorkTime (LocationNo,Title, WorkStart, WorkEnd, LunchStart, LunchEnd, IsAddLunch)
			VALUES (LocationNo,Title, WorkStart, WorkEnd, LunchStart, LunchEnd, IsAddLunch)
		END
	ELSE
		BEGIN;
			UPDATE WorkingTime_WorkTime
			SET Title=workingtime_setworkingtimeworktime.title,WorkStart=workingtime_setworkingtimeworktime.workstart,WorkEnd=workingtime_setworkingtimeworktime.workend,LunchStart=workingtime_setworkingtimeworktime.lunchstart,LunchEnd=workingtime_setworkingtimeworktime.lunchend,IsAddLunch=workingtime_setworkingtimeworktime.isaddlunch
			WHERE WorkTimeNo=workingtime_setworkingtimeworktime.worktimeno
		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
