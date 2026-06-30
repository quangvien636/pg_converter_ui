-- ─── PROCEDURE→FUNCTION: board_checkpermission ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.board_checkpermission(integer, integer);
CREATE OR REPLACE FUNCTION public.board_checkpermission(
    IN itemno integer DEFAULT 95,
    IN itemtype integer DEFAULT 1
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF(ItemType=2)
	BEGIN 
		RETURN QUERY
		SELECT /* TOP 1 */ CASE WHEN BB.SpecType=1  THEN FALSE ELSE  TRUE END  AS IsPermission,FALSE  AS IsDisablePermission
		FROM Board_Boards BB 
		WHERE  ItemNo=BB.BoardNo
	END;
	ELSE BEGIN
	RETURN QUERY
	SELECT /* TOP 1 */ CASE WHEN FC.SpecType=1  THEN FALSE ELSE  TRUE END  AS IsPermission ,
			  FALSE  AS IsDisablePermission 
	FROM Board_Folders FC
	WHERE  ItemNo=FC.FolderNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
