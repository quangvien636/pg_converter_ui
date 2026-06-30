-- ─── PROCEDURE→FUNCTION: board_insertdepartallowaccess ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_insertdepartallowaccess(integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.board_insertdepartallowaccess(
    IN departno integer DEFAULT 6355,
    IN allowvalue integer DEFAULT 0,
    IN itemno integer DEFAULT 1160,
    IN itemtype integer DEFAULT 2,
    IN userno integer DEFAULT 70
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Board_DepartAllowAccess (DepartNo,AllowValue , ItemNo,ItemType,RegUserNo,RegDate,ModUserNo,ModDate)
	VALUES (DepartNo, AllowValue, ItemNo,ItemType,UserNo,NOW(),UserNo,NOW())
	RETURN QUERY
	SELECT lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
