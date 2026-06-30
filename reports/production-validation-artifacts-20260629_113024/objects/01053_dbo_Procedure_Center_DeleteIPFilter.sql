-- ─── PROCEDURE→FUNCTION: center_deleteipfilter ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_deleteipfilter(integer);
CREATE OR REPLACE FUNCTION public.center_deleteipfilter(
    IN filterno integer
) RETURNS SETOF record
AS $function$
DECLARE
    sortno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT SortNo INTO sortno FROM Center_IPFilters WHERE FilterNo = center_deleteipfilter.filterno

	DELETE FROM Center_IPFilters WHERE FilterNo = center_deleteipfilter.filterno
	
	UPDATE Center_IPFilters SET SortNo = SortNo - 1
	WHERE SortNo > SortNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
