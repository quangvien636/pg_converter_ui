-- ─── PROCEDURE→FUNCTION: work_insertworkassistant ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_insertworkassistant(integer, integer);
CREATE OR REPLACE FUNCTION public.work_insertworkassistant(
    IN historyno integer,
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkAssistants(HistoryNo, UserNo)
	VALUES(HistoryNo, UserNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
