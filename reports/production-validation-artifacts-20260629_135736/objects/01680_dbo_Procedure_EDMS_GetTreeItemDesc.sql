-- ─── PROCEDURE→FUNCTION: edms_gettreeitemdesc ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edms_gettreeitemdesc();
CREATE OR REPLACE FUNCTION public.edms_gettreeitemdesc(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    -- INSERT INTO statements for procedure here
	RETURN QUERY
	SELECT Desc1, Desc2, Desc3 FROM EDMSTreeItemDesc WHERE Id = Id And DivID = DivId;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
