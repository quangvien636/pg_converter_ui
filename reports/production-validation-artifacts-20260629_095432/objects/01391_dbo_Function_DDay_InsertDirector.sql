-- ─── FUNCTION: dday_insertdirector ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_insertdirector(bigint, integer);
CREATE OR REPLACE FUNCTION public.dday_insertdirector(
    dayno bigint,
    userno integer
) RETURNS TABLE(
    directorno text
)
AS $function$
DECLARE
    directorno bigint;
BEGIN


	DELETE FROM DDay_Directors WHERE DayNo = dday_insertdirector.dayno

	INSERT INTO DDay_Directors VALUES (DayNo, UserNo)


	SET DirectorNo = COALESCE(lastval(), 0)

	RETURN QUERY
	SELECT DirectorNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
