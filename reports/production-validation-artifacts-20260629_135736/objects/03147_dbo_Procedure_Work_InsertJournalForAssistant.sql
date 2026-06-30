-- ─── PROCEDURE→FUNCTION: work_insertjournalforassistant ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_insertjournalforassistant(integer, timestamp without time zone, integer, date, integer, integer);
CREATE OR REPLACE FUNCTION public.work_insertjournalforassistant(
    IN reguserno integer,
    IN regdate timestamp without time zone,
    IN workno integer,
    IN creationdate date,
    IN divisionno integer,
    IN worktime integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkJournals (RegUserNo, RegDate, ModUserNo, ModDate,
		WorkNo, CreationDate, DivisionNo, WorkTime, CompletionRate, Content)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate,
		WorkNo, CreationDate, DivisionNo, WorkTime, -1, Content);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
