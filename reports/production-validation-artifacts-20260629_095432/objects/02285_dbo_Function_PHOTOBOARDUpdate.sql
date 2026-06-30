-- ─── FUNCTION: photoboardupdate ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboardupdate(integer, character varying, text, character varying, character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.photoboardupdate(
    id integer,
    title character varying,
    content text,
    positionid character varying,
    departid character varying,
    worder integer,
    wlevel integer,
    wgroup integer
) RETURNS void
AS $function$
BEGIN
UPDATE PhotoBoard
 SET 
  --ID = ID,  
  Title = photoboardupdate.title, 
  Content = photoboardupdate.content, 
  PositionID = photoboardupdate.positionid,  
  DepartID = photoboardupdate.departid, 
  Worder = photoboardupdate.worder, 
  Wlevel = photoboardupdate.wlevel, 
  WGroup = photoboardupdate.wgroup, 
  Hit = Hit+1,  
  ModDate = NOW() 
WHERE ID = photoboardupdate.id ;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
