-- ─── PROCEDURE→FUNCTION: board_updatenoticepermission ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_updatenoticepermission(integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.board_updatenoticepermission(
    IN departno integer DEFAULT 49,
    IN positionno integer DEFAULT 23,
    IN userno integer DEFAULT 6656,
    IN allowvalue integer DEFAULT 2,
    IN itemno integer DEFAULT 137
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	DELETE FROM Board_NoticePermission
	WHERE UserNo = board_updatenoticepermission.userno AND ItemNo=board_updatenoticepermission.itemno;
	IF AllowValue >0 THEN
		INSERT INTO public."Board_NoticePermission"(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ModDate,RegDate)
		VALUES(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,NOW(),NOW());;
	END IF;
	RETURN QUERY
	SELECT ItemNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.