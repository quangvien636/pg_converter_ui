-- â”€â”€â”€ PROCEDUREâ†’FUNCTION: board_updatefolder â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output â€” stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record â€” procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_updatefolder(integer, integer, timestamp without time zone, character varying, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_updatefolder(
    IN folderno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN name character varying,
    IN parentno integer,
    IN sortno integer,
    IN enabled boolean
) RETURNS void
AS $function$
DECLARE
    levelrand character varying;
-- !! WARNING: output needs manual review â€” see TODO comments
BEGIN

	IF PARENTNO >0 THEN
		SELECT LevelRand || FolderNo::text || ',' INTO levelrand FROM Board_Folders WHERE FolderNo=board_updatefolder.parentno;
	ELSE
		LevelRand := ',';
	END IF;
UPDATE public."Board_Folders"
   SET ModUserNo = board_updatefolder.moduserno
      ,ModDate = board_updatefolder.moddate
      ,Name = board_updatefolder.name
      ,ParentNo = board_updatefolder.parentno
      ,SortNo = board_updatefolder.sortno
      ,Enabled = board_updatefolder.enabled
	  ,LevelRand = LevelRand 
 WHERE FolderNo=board_updatefolder.folderno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.