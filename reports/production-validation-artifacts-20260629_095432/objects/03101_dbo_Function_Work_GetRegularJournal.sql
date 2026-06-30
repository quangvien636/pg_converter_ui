-- ─── FUNCTION: work_getregularjournal ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getregularjournal(integer);
CREATE OR REPLACE FUNCTION public.work_getregularjournal(
    journalno integer
) RETURNS TABLE(
    journalno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    groupno text,
    creationdate text,
    title text,
    divisionno text,
    worktime text,
    content text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT JournalNo, RegUserNo, RegDate, ModUserNo, ModDate,
		GroupNo, CreationDate, Title, DivisionNo, WorkTime, Content
	FROM RegularWorkJournals
	WHERE JournalNo = work_getregularjournal.journalno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
