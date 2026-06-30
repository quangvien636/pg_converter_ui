-- ─── FUNCTION: schedule_insertddaysrepeat ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertddaysrepeat(date, date, character varying);
CREATE OR REPLACE FUNCTION public.schedule_insertddaysrepeat(
    repeatdate date,
    completedate date DEFAULT 'GETDATE',
    iscomplete character varying DEFAULT 'N'
) RETURNS void
AS $function$
BEGIN


	IF CONVERT(VARCHAR(8),RepeatDate,112) < CONVERT(VARCHAR(8),NOW(),112)
	BEGIN
		SET CompleteDate = schedule_insertddaysrepeat.repeatdate
		SET IsComplete = 'Y'
	END
	
	INSERT INTO ScheduleDdaysRepeat
           (DdayNo
           ,RepeatDate
           ,CompleteDate
           ,IsComplete)
     VALUES
           (DdayNo
           ,RepeatDate
           ,CompleteDate
           ,IsComplete);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
