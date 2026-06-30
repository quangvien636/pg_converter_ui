-- ─── PROCEDURE→FUNCTION: schedule_inserttodoforoutlookentryid ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_inserttodoforoutlookentryid(integer);
CREATE OR REPLACE FUNCTION public.schedule_inserttodoforoutlookentryid(
    IN todono integer
) RETURNS SETOF record
AS $function$
DECLARE
    cnt integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT COUNT(ToDoNo) INTO cnt FROM ScheduleToDosOutlook
	WHERE UserNo = UserNo
	AND ToDoNo = schedule_inserttodoforoutlookentryid.todono
	
	IF CNT = 0 THEN
	
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
	
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
