-- ─── FUNCTION: board_checkallowbyitem ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_checkallowbyitem(integer);
CREATE OR REPLACE FUNCTION public.board_checkallowbyitem(
    userno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT (SELECT COUNT(*)   FROM Board_AllowAccess WHERE UserNo=board_checkallowbyitem.userno AND ItemNo=  ItemNo AND ItemType=ItemType AND  (AllowValue & Role) > 0)
	+(SELECT  COUNT(*) FROM Board_DepartAllowAccess BD
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo AND OB.UserNo=board_checkallowbyitem.userno
	WHERE  BD.ItemNo=  ItemNo AND BD.ItemType=ItemType AND  (BD.AllowValue & Role) > 0);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
