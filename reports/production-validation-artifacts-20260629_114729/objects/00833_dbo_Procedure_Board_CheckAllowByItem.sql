-- ─── PROCEDURE→FUNCTION: board_checkallowbyitem ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_checkallowbyitem(integer);
CREATE OR REPLACE FUNCTION public.board_checkallowbyitem(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
