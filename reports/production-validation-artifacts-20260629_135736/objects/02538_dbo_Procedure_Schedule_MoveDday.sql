-- ─── PROCEDURE→FUNCTION: schedule_movedday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_movedday(integer, date);
CREATE OR REPLACE FUNCTION public.schedule_movedday(
    IN ddayno integer,
    IN doomdate date
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleDdays
	ModUserNo := UserNo,;
		ModDate = NOW(),
		DoomDate = schedule_movedday.doomdate
	WHERE DdayNo = schedule_movedday.ddayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
