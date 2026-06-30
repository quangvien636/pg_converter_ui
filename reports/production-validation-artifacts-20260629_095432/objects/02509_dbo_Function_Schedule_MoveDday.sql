-- ─── FUNCTION: schedule_movedday ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_movedday(integer, date);
CREATE OR REPLACE FUNCTION public.schedule_movedday(
    ddayno integer,
    doomdate date
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleDdays
	SET
		ModUserNo = UserNo,
		ModDate = NOW(),
		DoomDate = schedule_movedday.doomdate
	WHERE DdayNo = schedule_movedday.ddayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
