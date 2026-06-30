-- ─── PROCEDURE→FUNCTION: board_checkpermission ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_checkpermission(integer, integer);
CREATE OR REPLACE FUNCTION public.board_checkpermission(
    IN itemno integer DEFAULT 95,
    IN itemtype integer DEFAULT 1
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF ItemType=2 THEN
		RETURN QUERY
		SELECT CASE WHEN BB.SpecType=1  THEN FALSE ELSE  TRUE END  AS IsPermission,FALSE  AS IsDisablePermission
		FROM Board_Boards BB 
		WHERE  ItemNo=BB.BoardNo
	ELSE
	RETURN QUERY
	SELECT CASE WHEN FC.SpecType=1  THEN FALSE ELSE  TRUE END  AS IsPermission ,
			  FALSE  AS IsDisablePermission 
	FROM Board_Folders FC
	WHERE  ItemNo=FC.FolderNo;;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.