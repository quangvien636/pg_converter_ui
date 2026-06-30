-- ─── FUNCTION: edms_getpubliclevels ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getpubliclevels();
CREATE OR REPLACE FUNCTION public.edms_getpubliclevels(
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
	FROM EDMS_PublicLevels;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
