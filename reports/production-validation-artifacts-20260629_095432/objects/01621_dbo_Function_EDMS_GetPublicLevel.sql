-- ─── FUNCTION: edms_getpubliclevel ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getpubliclevel(integer);
CREATE OR REPLACE FUNCTION public.edms_getpubliclevel(
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
	FROM EDMS_PublicLevels
	WHERE LevelNo = edms_getpubliclevel.levelno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
