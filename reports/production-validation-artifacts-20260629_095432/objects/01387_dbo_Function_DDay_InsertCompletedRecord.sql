-- ─── FUNCTION: dday_insertcompletedrecord ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_insertcompletedrecord(bigint, integer, timestamp without time zone, date);
CREATE OR REPLACE FUNCTION public.dday_insertcompletedrecord(
    dayno bigint,
    reguserno integer,
    regdate timestamp without time zone,
    completeddate date
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    recordno bigint;
BEGIN


	INSERT INTO DDay_CompletedRecords VALUES (DayNo, RegUserNo, RegDate, CompletedDate, Comment)


	SET RecordNo = lastval()

	RETURN QUERY
	SELECT RecordNo

	EXEC DDay_DeleteCountOfAppBadge DayNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
