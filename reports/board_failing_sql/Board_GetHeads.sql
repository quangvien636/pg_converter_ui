-- ─── PROCEDURE→FUNCTION: board_getheads ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getheads(integer, boolean);
CREATE OR REPLACE FUNCTION public.board_getheads(
    IN boardno integer,
    IN isdisabled boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF IsDisabled = TRUE THEN
	
		RETURN QUERY
		SELECT HeadNo, BoardNo, ModUserNo, ModDate, Name, SortNo, Enabled
		FROM Board_Heads
		ORDER BY SortNO ASC;
	
	
	ELSE
	
		RETURN QUERY
		SELECT HeadNo, BoardNo, ModUserNo, ModDate, Name, SortNo, Enabled
		FROM Board_Heads
		WHERE Enabled = TRUE
		ORDER BY SortNO ASC
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.