-- ─── PROCEDURE→FUNCTION: schedule_insertddayshistory ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertddayshistory(character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertddayshistory(
    IN historytype character varying,
    IN reguserno integer
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
