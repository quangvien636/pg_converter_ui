-- ─── PROCEDURE→FUNCTION: integrated_gettreeitembyid ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.integrated_gettreeitembyid(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.integrated_gettreeitembyid(
    IN parentid integer,
    IN treeid integer,
    IN useyn character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT *	
		FROM Integrated_TreeItem
		WHERE	PARENTID = integrated_gettreeitembyid.parentid	
		--and TreeID	=	TreeID
		and UseYn = integrated_gettreeitembyid.useyn;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
