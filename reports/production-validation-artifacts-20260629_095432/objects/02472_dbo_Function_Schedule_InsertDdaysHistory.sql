-- ─── FUNCTION: schedule_insertddayshistory ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertddayshistory(character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertddayshistory(
    historytype character varying,
    reguserno integer
) RETURNS void
AS $function$
BEGIN

	INSERT INTO ScheduleDdaysHistory
	(
		DdayNo,
		HistoryType,
		RegDate,
		RegUserNo
	)
	VALUES
	(
		DdayNo,
		HistoryType,
		NOW(),
		RegUserNo
	);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
