-- ─── PROCEDURE→FUNCTION: schedule_updatetodo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updatetodo(integer, integer, timestamp without time zone, character varying, integer, integer, date, boolean, boolean, boolean, boolean, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_updatetodo(
    IN todono integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
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
) RETURNS void
AS $function$
BEGIN


	UPDATE ScheduleToDos SET
		ModUserNo = schedule_updatetodo.moduserno,
		ModDate = schedule_updatetodo.moddate,
		Title = schedule_updatetodo.title,
		GroupNo = schedule_updatetodo.groupno,
		Important = schedule_updatetodo.important,
		CompleteDate = schedule_updatetodo.completedate,
		IsComplete = schedule_updatetodo.iscomplete,
		IsNotiNote = schedule_updatetodo.isnotinote,
		IsNotiMail = schedule_updatetodo.isnotimail,
		IsNotiSMS = schedule_updatetodo.isnotisms,
		IsNotiPopup = schedule_updatetodo.isnotipopup,
		NotiTimeType = schedule_updatetodo.notitimetype,
		ProgressRate = schedule_updatetodo.progressrate
	WHERE ToDoNo = schedule_updatetodo.todono;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
