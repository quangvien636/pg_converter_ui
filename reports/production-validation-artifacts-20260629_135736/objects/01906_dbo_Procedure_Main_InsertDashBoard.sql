-- ─── PROCEDURE→FUNCTION: main_insertdashboard ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.main_insertdashboard(integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.main_insertdashboard(
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    boardno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Main_DashBoards (ModUserNo, ModDate, Name)
	VALUES (ModUserNo, ModDate, Name)
	

	BoardNo := lastval();
	RETURN QUERY
	SELECT BoardNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
