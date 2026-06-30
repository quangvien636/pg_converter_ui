-- ─── PROCEDURE→FUNCTION: schedule_insertcontentshistory ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertcontentshistory(character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertcontentshistory(
    IN historytype character varying,
    IN reguserno integer
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
