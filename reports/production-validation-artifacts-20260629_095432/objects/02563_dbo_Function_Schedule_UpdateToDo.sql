-- ─── FUNCTION: schedule_updatetodo ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updatetodo(integer, integer, timestamp without time zone, character varying, integer, integer, date, boolean, boolean, boolean, boolean, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_updatetodo(
    todono integer,
    moduserno integer,
    moddate timestamp without time zone,
    title character varying,
    groupno integer,
    important integer,
    completedate date,
    iscomplete boolean,
    isnotinote boolean,
    isnotimail boolean,
    isnotisms boolean,
    isnotipopup boolean,
    notitimetype integer,
    progressrate integer DEFAULT -1
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
