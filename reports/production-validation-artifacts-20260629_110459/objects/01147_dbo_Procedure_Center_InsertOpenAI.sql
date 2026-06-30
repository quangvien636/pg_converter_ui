-- ─── PROCEDURE→FUNCTION: center_insertopenai ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_insertopenai(integer, integer);
CREATE OR REPLACE FUNCTION public.center_insertopenai(
    IN userno integer,
    IN type integer
) RETURNS SETOF record
AS $function$
DECLARE
    no bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Center_OpenAI(UserNo,Type,Messages,Date)
	VALUES(UserNo, Type, Messages,NOW())
	

	No := lastval();
	RETURN QUERY
	SELECT No;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
