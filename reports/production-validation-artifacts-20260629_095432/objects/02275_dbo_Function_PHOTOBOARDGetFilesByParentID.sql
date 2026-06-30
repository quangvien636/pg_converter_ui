-- ─── FUNCTION: photoboardgetfilesbyparentid ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboardgetfilesbyparentid(integer);
CREATE OR REPLACE FUNCTION public.photoboardgetfilesbyparentid(
    parentid integer
) RETURNS TABLE(
    seq serial,
    parentid integer,
    filename character varying(512),
    firstflag boolean
)
AS $function$
BEGIN
 RETURN QUERY
 SELECT * FROM PhotoBoardFile WHERE ParentID=photoboardgetfilesbyparentid.parentid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
