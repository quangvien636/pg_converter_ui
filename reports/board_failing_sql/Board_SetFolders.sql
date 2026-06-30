-- ─── PROCEDURE→FUNCTION: board_setfolders ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_setfolders(integer, timestamp without time zone, character varying, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_setfolders(
    IN mod_user_id integer,
    IN date timestamp without time zone,
    IN name character varying,
    IN parentno integer,
    IN sortno integer,
    IN enabled boolean
) RETURNS SETOF record
AS $function$
DECLARE
    levelrand character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


 IF PARENTNO >0 THEN
  SELECT LevelRand + CONVERT(nvarchar(20), FolderNo) + ',' INTO levelrand FROM Board_Folders WHERE FolderNo=board_setfolders.parentno;
 ELSE
  LevelRand := ',';
 END;
 INSERT INTO Board_Folders(ModUserNo, ModDate, Name, ParentNo, SortNo,Enabled,LevelRand) VALUES (MOD_USER_ID, DATE, NAME, PARENTNO, SORTNO, ENABLED,LevelRand);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.