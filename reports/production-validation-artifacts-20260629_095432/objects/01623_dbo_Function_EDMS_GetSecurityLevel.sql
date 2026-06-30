-- ─── FUNCTION: edms_getsecuritylevel ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getsecuritylevel(integer);
CREATE OR REPLACE FUNCTION public.edms_getsecuritylevel(
    levelno integer
) RETURNS TABLE(
    levelno text,
    moduserno text,
    moddate text,
    name text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT LevelNo, ModUserNo, ModDate, Name
	FROM EDMS_SecurityLevels
	WHERE LevelNo = edms_getsecuritylevel.levelno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
