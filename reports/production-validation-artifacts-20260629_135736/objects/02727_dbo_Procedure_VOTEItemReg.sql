-- ─── PROCEDURE→FUNCTION: voteitemreg ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.voteitemreg(integer, character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.voteitemreg(
    IN parentid integer,
    IN title character varying,
    IN type integer,
    IN cnt integer,
    IN selectoption integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO VOTEItem
		(ParentID
		,Title
		,Type
		,Cnt
		,SelectOption)
	VALUES
		(ParentID
		,Title
		,Type
		,Cnt
		,SelectOption)

	RETURN QUERY
	SELECT lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
