-- ─── FUNCTION: schedule_inserttodo ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_inserttodo(integer, timestamp without time zone, character varying, integer, integer, date, boolean, boolean, boolean, boolean, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_inserttodo(
    reguserno integer,
    regdate timestamp without time zone,
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
) RETURNS TABLE(
    todono text
)
AS $function$
DECLARE
    todono integer;
BEGIN


	INSERT INTO ScheduleToDos (
		RegUserNo, RegDate, ModUserNo, ModDate, Title, GroupNo, Important, CompleteDate, IsComplete,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, ProgressRate)
	VALUES (RegUserNo, RegDate, RegUserNo, RegDate, Title, GroupNo, Important, CompleteDate, IsComplete,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, ProgressRate)
		

	SET ToDoNo = lastval()
	
	RETURN QUERY
	SELECT ToDoNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
