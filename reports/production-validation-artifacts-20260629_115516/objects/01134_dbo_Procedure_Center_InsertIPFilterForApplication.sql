-- ─── PROCEDURE→FUNCTION: center_insertipfilterforapplication ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_insertipfilterforapplication(integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.center_insertipfilterforapplication(
    IN applicationno integer,
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
	FROM Center_IPFiltersForApplication
	WHERE ApplicationNo = center_insertipfilterforapplication.applicationno
	
	INSERT INTO Center_IPFiltersForApplication (ApplicationNo, ClientIP, Allow, SortNo)
	VALUES (ApplicationNo, ClientIP, Allow, SortNo + 1)
	

	FilterNo := lastval();
	RETURN QUERY
	SELECT FilterNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
