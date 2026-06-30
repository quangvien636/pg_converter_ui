-- ─── FUNCTION: dday_getcompletedrecordsfordays ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_getcompletedrecordsfordays();
CREATE OR REPLACE FUNCTION public.dday_getcompletedrecordsfordays(
) RETURNS TABLE(
    recordno bigserial,
    dayno bigint,
    reguserno integer,
    regdate timestamp without time zone,
    completeddate date,
    comment text
)
AS $function$
DECLARE
    query character varying;
    result table (
		recordno		bigint,
		dayno			bigint,
		completeddate	date
	);
BEGIN



	SET Query =
		'SELECT RecordNo, DayNo, CompletedDate FROM DDay_CompletedRecords ' +
		'WHERE DayNo IN (' || ListOfDays || ') ' +
		'ORDER BY CompletedDate DESC'


	INSERT INTO Result
	EXEC SP_EXECUTESQL Query

	RETURN QUERY
	SELECT * FROM Result;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
