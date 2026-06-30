-- ─── FUNCTION: edms_getcategory ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getcategory(integer);
CREATE OR REPLACE FUNCTION public.edms_getcategory(
    categoryno integer
) RETURNS TABLE(
    categoryno text,
    moduserno text,
    moddate text,
    parentno text,
    name text,
    enabled text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT CategoryNo, ModUserNo, ModDate, ParentNo, Name, Enabled
	FROM EDMS_Categories
	WHERE CategoryNo = edms_getcategory.categoryno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
