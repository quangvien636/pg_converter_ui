-- ─── FUNCTION: schedule_inserttodoforoutlookentryid ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_inserttodoforoutlookentryid(integer);
CREATE OR REPLACE FUNCTION public.schedule_inserttodoforoutlookentryid(
    todono integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    cnt integer;
BEGIN



	SELECT CNT = COUNT(ToDoNo) FROM ScheduleToDosOutlook
	WHERE UserNo = UserNo
	AND ToDoNo = schedule_inserttodoforoutlookentryid.todono
	
	IF CNT = 0
	BEGIN
	
	INSERT INTO ScheduleToDosOutlook
	(
		UserNo,
		ToDoNo,
		OutlookEntryID
	)
	VALUES
	(
		UserNo,
		ToDoNo,
		OutlookEntryID
	)
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
