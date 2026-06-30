-- ─── PROCEDURE→FUNCTION: work_updateregularjournal ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_updateregularjournal(integer, integer, timestamp without time zone, date, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.work_updateregularjournal(
    IN journalno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN creationdate date,
    IN title character varying,
    IN divisionno integer,
    IN worktime integer
) RETURNS void
AS $function$
BEGIN


	UPDATE RegularWorkJournals SET
		ModUserNo = work_updateregularjournal.moduserno,
		ModDate = work_updateregularjournal.moddate,
		CreationDate = work_updateregularjournal.creationdate,
		Title = work_updateregularjournal.title,
		DivisionNo = work_updateregularjournal.divisionno,
		WorkTime = work_updateregularjournal.worktime,
		Content = Content
	WHERE JournalNo = work_updateregularjournal.journalno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
