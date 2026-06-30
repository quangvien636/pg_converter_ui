-- ─── PROCEDURE→FUNCTION: schedule_insertddaysrepeat ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertddaysrepeat(date, date, character varying);
CREATE OR REPLACE FUNCTION public.schedule_insertddaysrepeat(
    IN repeatdate date,
    IN completedate date DEFAULT 'GETDATE',
    IN iscomplete character varying DEFAULT 'N'
) RETURNS void
AS $function$
BEGIN


	IF CONVERT(VARCHAR(8),RepeatDate,112) < CONVERT(VARCHAR(8),NOW(),112) THEN
		CompleteDate := schedule_insertddaysrepeat.repeatdate;
		IsComplete := 'Y';
	END IF;
	
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
