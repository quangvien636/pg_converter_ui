-- ─── FUNCTION: edms_getsecuritylevels ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getsecuritylevels();
CREATE OR REPLACE FUNCTION public.edms_getsecuritylevels(
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
	FROM EDMS_SecurityLevels;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
