-- ─── PROCEDURE→FUNCTION: board_getallowbyitem ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getallowbyitem(integer, integer);
CREATE OR REPLACE FUNCTION public.board_getallowbyitem(
    IN itemno integer,
    IN itemtype integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	
		RETURN QUERY
		SELECT *
		FROM Board_AllowAccess
		WHERE ItemNo = board_getallowbyitem.itemno AND ItemType=board_getallowbyitem.itemtype;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
