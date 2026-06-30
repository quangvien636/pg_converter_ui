-- ─── FUNCTION: schedule_insertcontentshistory ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertcontentshistory(character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertcontentshistory(
    historytype character varying,
    reguserno integer
) RETURNS void
AS $function$
BEGIN

	INSERT INTO ScheduleContentsHistory
	(
		ScheduleNo,
		HistoryType,
		RegDate,
		RegUserNo
	)
	VALUES
	(
		ScheduleNo,
		HistoryType,
		NOW(),
		RegUserNo
	);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
