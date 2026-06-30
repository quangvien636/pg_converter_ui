-- ─── PROCEDURE→FUNCTION: schedule_deleteddaysall ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_deleteddaysall(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteddaysall(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
