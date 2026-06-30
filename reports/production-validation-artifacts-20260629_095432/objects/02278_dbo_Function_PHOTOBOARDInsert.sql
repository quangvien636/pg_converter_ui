-- ─── FUNCTION: photoboardinsert ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboardinsert(character varying, text, character varying, character varying, character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.photoboardinsert(
    title character varying,
    content text,
    writerid character varying,
    positionid character varying,
    departid character varying,
    worder integer,
    wlevel integer,
    wgroup integer
) RETURNS TABLE(
    col1 text
)
AS $function$
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
