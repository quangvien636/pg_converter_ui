-- ─── FUNCTION: worktodo_getjournals ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_getjournals(bigint);
CREATE OR REPLACE FUNCTION public.worktodo_getjournals(
    datano bigint
) RETURNS TABLE(
    journalno text,
    moduserno text,
    moddate text,
    writedate text,
    progressrate text,
    worktime text,
    content text,
    typeno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT JournalNo, ModUserNo, ModDate, WriteDate, ProgressRate, WorkTime, Content, TypeNo
	FROM WorkToDo_Journals
	WHERE DataNo = worktodo_getjournals.datano
	ORDER BY WriteDate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
