-- ─── FUNCTION: schedule_deleteddaysover ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteddaysover(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteddaysover(
    userno integer
) RETURNS TABLE(
    ddayno text,
    col2 text,
    col3 text,
    userno text
)
AS $function$
BEGIN

	INSERT INTO ScheduleDdaysHistory
	(
		DdayNo,
		HistoryType,
		RegDate,
		RegUserNo
	)
	RETURN QUERY
	SELECT DdayNo, 'D', NOW(), UserNo
	FROM ScheduleDdays WHERE RegUserNo = schedule_deleteddaysover.userno
	AND RepeatEndDate < CONVERT(DATE,NOW())
	
	DELETE FROM ScheduleDdays WHERE RegUserNo = schedule_deleteddaysover.userno AND RepeatEndDate < CONVERT(DATE,NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
