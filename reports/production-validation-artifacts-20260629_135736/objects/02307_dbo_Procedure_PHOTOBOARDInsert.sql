-- ─── PROCEDURE→FUNCTION: photoboardinsert ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.photoboardinsert(character varying, text, character varying, character varying, character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.photoboardinsert(
    IN title character varying,
    IN content text,
    IN writerid character varying,
    IN positionid character varying,
    IN departid character varying,
    IN worder integer,
    IN wlevel integer,
    IN wgroup integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
 INSERT INTO PhotoBoard(
  Title,   
  Content,  
  WriterID,  
  PositionID, 
  DepartID,  
  Worder,  
  Wlevel,  
  WGroup,  
  Hit,  
  RegDate 
) 
VALUES (
  TITLE,  
  CONTENT, 
  WRITERID, 
  POSITIONID,
  DEPARTID, 
  WORDER, 
  WLEVEL, 
  WGROUP, 
  0, 
  NOW()
);
RETURN QUERY
SELECT @IDENTITY;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
