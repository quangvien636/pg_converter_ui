-- ─── FUNCTION: work_insertcooperationfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertcooperationfile(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.work_insertcooperationfile(
    cooperationno integer,
    name character varying,
    length integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Work_CooperationFiles
	VALUES(CooperationNo, Name, Length);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
