-- ─── PROCEDURE→FUNCTION: voteresultreg ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.voteresultreg(integer, integer, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.voteresultreg(
    IN masterid integer,
    IN parentid integer,
    IN type integer,
    IN result character varying,
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	INSERT INTO VOTEResult
		(MasterID
		,ParentID
		,Type
		,UserNo
		,Result
		,PollDate)
	VALUES
		(MasterID
		,ParentID
		,Type
		,UserNo
		,Result
		,Now)

	RETURN QUERY
	SELECT lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
