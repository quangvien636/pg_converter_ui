-- ─── FUNCTION: schedule_inserttodoshistory ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_inserttodoshistory(character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_inserttodoshistory(
    historytype character varying,
    reguserno integer
) RETURNS void
AS $function$
BEGIN

	INSERT INTO ScheduleToDosHistory
	(
		ToDoNo,
		HistoryType,
		RegDate,
		RegUserNo
	)
	VALUES
	(
		ToDoNo,
		HistoryType,
		NOW(),
		RegUserNo
	);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
