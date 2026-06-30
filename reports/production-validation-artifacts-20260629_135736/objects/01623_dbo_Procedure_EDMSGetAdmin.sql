-- ─── PROCEDURE→FUNCTION: edmsgetadmin ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmsgetadmin();
CREATE OR REPLACE FUNCTION public.edmsgetadmin(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	--*/	
	/***************************************************************************
	-- EDMSDOCUMENT INSERT
	***************************************************************************/
	RETURN QUERY
	SELECT	UserID
	,		''	as UserNm
	,		''	as GrpNm
	,		'' as OrgNm		
	FROM EDMSUSERENV 
	WHERE	ADMINFLAG = 'Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
