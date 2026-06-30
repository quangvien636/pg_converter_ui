-- ─── FUNCTION: board_checkpermission ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_checkpermission(integer, integer);
CREATE OR REPLACE FUNCTION public.board_checkpermission(
    itemno integer DEFAULT 95,
    itemtype integer DEFAULT 1
) RETURNS TABLE(
    ispermission text,
    isdisablepermission text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF(ItemType=2)
	BEGIN 
		RETURN QUERY
		SELECT /* TOP 1 */ CASE WHEN BB.SpecType=1  THEN FALSE ELSE  TRUE END  AS IsPermission,FALSE  AS IsDisablePermission
		FROM Board_Boards BB 
		WHERE  ItemNo=BB.BoardNo
	END
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
