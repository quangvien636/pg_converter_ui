-- ─── FUNCTION: workingtime_insertdisplaypath ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_insertdisplaypath(integer, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.workingtime_insertdisplaypath(
    startworkingno integer,
    endworkingno integer,
    paths character varying,
    distance integer
) RETURNS TABLE(
    pathno text
)
AS $function$
DECLARE
    pathno bigint;
BEGIN


	INSERT INTO WorkingTime_DisplayPaths (StartWorkingNo, EndWorkingNo, Paths, Distance)
	VALUES (StartWorkingNo, EndWorkingNo, Paths, Distance)


	SET PathNo = lastval()

	RETURN QUERY
	SELECT PathNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
