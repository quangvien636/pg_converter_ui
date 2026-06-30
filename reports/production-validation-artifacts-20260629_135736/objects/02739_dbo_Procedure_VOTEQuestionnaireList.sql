-- ─── PROCEDURE→FUNCTION: votequestionnairelist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.votequestionnairelist(integer);
CREATE OR REPLACE FUNCTION public.votequestionnairelist(
    IN id integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- List
	RETURN QUERY
	SELECT MasterID
	,No
	,Type
	,Name
	FROM public."VOTEQuestionnaire"
	WHERE MasterID = votequestionnairelist.id
	ORDER BY MasterID, Type, No;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
