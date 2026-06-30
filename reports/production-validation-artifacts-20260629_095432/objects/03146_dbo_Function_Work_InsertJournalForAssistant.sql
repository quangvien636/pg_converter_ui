-- ─── FUNCTION: work_insertjournalforassistant ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertjournalforassistant(integer, timestamp without time zone, integer, date, integer, integer);
CREATE OR REPLACE FUNCTION public.work_insertjournalforassistant(
    reguserno integer,
    regdate timestamp without time zone,
    workno integer,
    creationdate date,
    divisionno integer,
    worktime integer
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
