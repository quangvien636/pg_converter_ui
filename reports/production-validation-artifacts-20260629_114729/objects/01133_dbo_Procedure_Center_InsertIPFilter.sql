-- ─── PROCEDURE→FUNCTION: center_insertipfilter ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_insertipfilter(character varying, boolean);
CREATE OR REPLACE FUNCTION public.center_insertipfilter(
    IN clientip character varying,
    IN allow boolean
) RETURNS SETOF record
AS $function$
DECLARE
    sortno integer;
    filterno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SortNo := (COALESCE(MAX(SortNo), 0));
	FROM Center_IPFilters

	INSERT INTO Center_IPFilters (ClientIP, Allow, SortNo)
	VALUES (ClientIP, Allow, SortNo + 1)
	

	FilterNo := lastval();
	RETURN QUERY
	SELECT FilterNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
