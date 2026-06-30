-- ─── FUNCTION: schedule_deleteddaysall ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteddaysall(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteddaysall(
    userno integer
) RETURNS TABLE(
    ddayno text
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
	FROM ScheduleDdays WHERE RegUserNo = schedule_deleteddaysall.userno
	
	DELETE FROM ScheduleDdaysRepeat WHERE DdayNo in (SELECT DdayNo FROM ScheduleDdays WHERE RegUserNo = schedule_deleteddaysall.userno);
	DELETE FROM ScheduleDdays WHERE RegUserNo = schedule_deleteddaysall.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
