-- ─── FUNCTION: work_getcooperationfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getcooperationfiles(integer);
CREATE OR REPLACE FUNCTION public.work_getcooperationfiles(
    cooperationno integer
) RETURNS TABLE(
    fileno text,
    cooperationno text,
    name text,
    length text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT FileNo, CooperationNo, Name, Length
	FROM Work_CooperationFiles WHERE CooperationNo = work_getcooperationfiles.cooperationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
