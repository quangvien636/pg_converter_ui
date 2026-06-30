-- ─── PROCEDURE→FUNCTION: schedule_inserttodo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_inserttodo(integer, timestamp without time zone, character varying, integer, integer, date, boolean, boolean, boolean, boolean, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_inserttodo(
    IN reguserno integer,
    IN regdate timestamp without time zone,
    IN title character varying,
    IN groupno integer,
    IN important integer,
    IN completedate date,
    IN iscomplete boolean,
    IN isnotinote boolean,
    IN isnotimail boolean,
    IN isnotisms boolean,
    IN isnotipopup boolean,
    IN notitimetype integer,
    IN progressrate integer DEFAULT -1
) RETURNS SETOF record
AS $function$
DECLARE
    todono integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO ScheduleToDos (
		RegUserNo, RegDate, ModUserNo, ModDate, Title, GroupNo, Important, CompleteDate, IsComplete,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, ProgressRate)
	VALUES (RegUserNo, RegDate, RegUserNo, RegDate, Title, GroupNo, Important, CompleteDate, IsComplete,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, ProgressRate)
		

	ToDoNo := lastval();
	RETURN QUERY
	SELECT ToDoNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
