-- ─── FUNCTION: work_insertregularjournal ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertregularjournal(integer, timestamp without time zone, integer, date, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.work_insertregularjournal(
    reguserno integer,
    regdate timestamp without time zone,
    groupno integer,
    creationdate date,
    title character varying,
    divisionno integer,
    worktime integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO RegularWorkJournals (RegUserNo, RegDate, ModUserNo, ModDate,
		GroupNo, CreationDate, Title, DivisionNo, WorkTime, Content)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate,
		GroupNo, CreationDate, Title, DivisionNo, WorkTime, Content);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
