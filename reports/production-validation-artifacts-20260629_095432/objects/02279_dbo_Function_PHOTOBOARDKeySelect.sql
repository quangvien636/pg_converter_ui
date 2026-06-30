-- ─── FUNCTION: photoboardkeyselect ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboardkeyselect(integer, integer);
CREATE OR REPLACE FUNCTION public.photoboardkeyselect(
    id integer,
    langindex integer
) RETURNS TABLE(
    id text,
    title text,
    content text,
    writerid text,
    positionid text,
    departid text,
    worder text,
    wlevel text,
    wgroup text,
    hit text,
    regdate text,
    moddate text,
    username text
)
AS $function$
BEGIN
RETURN QUERY
SELECT
  ID,   
  TITLE, 
  CONTENT, 
  WRITERID, 
  POSITIONID, 
  DEPARTID, 
  WORDER,  
  WLEVEL, 
  WGROUP, 
  HIT,  
  REGDATE, 
  MODDATE,  '' as UserName
FROM PhotoBoard 
   WHERE ID = photoboardkeyselect.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
