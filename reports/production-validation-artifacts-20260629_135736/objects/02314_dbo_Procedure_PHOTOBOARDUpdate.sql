-- ─── PROCEDURE→FUNCTION: photoboardupdate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.photoboardupdate(integer, character varying, text, character varying, character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.photoboardupdate(
    IN id integer,
    IN title character varying,
    IN content text,
    IN positionid character varying,
    IN departid character varying,
    IN worder integer,
    IN wlevel integer,
    IN wgroup integer
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
