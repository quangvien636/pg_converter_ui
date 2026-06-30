-- ─── FUNCTION: schedule_deletetodosall ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deletetodosall();
CREATE OR REPLACE FUNCTION public.schedule_deletetodosall(
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
	WHERE RegUserNo = UserNo;
	
	DELETE FROM ScheduleToDos WHERE RegUserNo = UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
