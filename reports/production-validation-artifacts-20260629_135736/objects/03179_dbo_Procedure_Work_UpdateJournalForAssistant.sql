-- ─── PROCEDURE→FUNCTION: work_updatejournalforassistant ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_updatejournalforassistant(integer, integer, timestamp without time zone, integer, date, integer, integer);
CREATE OR REPLACE FUNCTION public.work_updatejournalforassistant(
    IN journalno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN workno integer,
    IN creationdate date,
    IN divisionno integer,
    IN worktime integer
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkJournals SET
		ModUserNo = work_updatejournalforassistant.moduserno,
		ModDate = work_updatejournalforassistant.moddate,
		CreationDate = work_updatejournalforassistant.creationdate,
		DivisionNo = work_updatejournalforassistant.divisionno,
		WorkTime = work_updatejournalforassistant.worktime,
		Content = Content
	WHERE JournalNo = work_updatejournalforassistant.journalno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
