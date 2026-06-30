-- ─── FUNCTION: schedule_deletetodoscomplete ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deletetodoscomplete();
CREATE OR REPLACE FUNCTION public.schedule_deletetodoscomplete(
) RETURNS TABLE(
    todono text,
    col2 text,
    col3 text,
    reguserno text
)
AS $function$
BEGIN

	INSERT INTO ScheduleToDosHistory
	(
		ToDoNo,
		HistoryType,
		RegDate,
		RegUserNo
	)
	RETURN QUERY
	SELECT ToDoNo, 'D', NOW(), RegUserNo
	FROM ScheduleToDos
	WHERE RegUserNo = UserNo AND IsComplete = TRUE
	
	DELETE FROM ScheduleToDos WHERE RegUserNo = UserNo AND IsComplete = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
