-- ─── FUNCTION: work_updateregularjournal ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updateregularjournal(integer, integer, timestamp without time zone, date, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.work_updateregularjournal(
    journalno integer,
    moduserno integer,
    moddate timestamp without time zone,
    creationdate date,
    title character varying,
    divisionno integer,
    worktime integer
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
