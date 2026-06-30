-- ─── PROCEDURE→FUNCTION: photoboardcmtupdate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.photoboardcmtupdate(integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.photoboardcmtupdate(
    IN id integer,
    IN parentid integer,
    IN writerid character varying,
    IN comment character varying
) RETURNS void
AS $function$
BEGIN
UPDATE PhotoBoardCmt
 ParentID := photoboardcmtupdate.parentid,;
  WriterID = photoboardcmtupdate.writerid,  
  Comment = photoboardcmtupdate.comment  
WHERE ID = photoboardcmtupdate.id ;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
