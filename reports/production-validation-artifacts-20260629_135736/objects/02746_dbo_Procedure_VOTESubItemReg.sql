-- ─── PROCEDURE→FUNCTION: votesubitemreg ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.votesubitemreg(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.votesubitemreg(
    IN parentid integer,
    IN masterid integer,
    IN title character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO VOTESubItem
		(ParentID
		,MasterID
		,Title)
		VALUES
		(ParentID
		,MasterID
		,Title)

	RETURN QUERY
	SELECT lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
