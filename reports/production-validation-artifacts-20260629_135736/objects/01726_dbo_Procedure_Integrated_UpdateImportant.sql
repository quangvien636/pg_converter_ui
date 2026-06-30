-- ─── PROCEDURE→FUNCTION: integrated_updateimportant ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.integrated_updateimportant(integer, boolean);
CREATE OR REPLACE FUNCTION public.integrated_updateimportant(
    IN integratedno integer,
    IN important boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Integrateds
	Important := integrated_updateimportant.important,;
	IsImportant= FALSE
	WHERE  IntegratedNo = integrated_updateimportant.integratedno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
