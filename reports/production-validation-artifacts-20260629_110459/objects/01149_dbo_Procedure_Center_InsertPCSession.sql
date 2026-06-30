-- ─── PROCEDURE→FUNCTION: center_insertpcsession ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_insertpcsession(integer);
CREATE OR REPLACE FUNCTION public.center_insertpcsession(
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    sessionno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Center_PCSessions (UserNo, SessionID)
	VALUES (UserNo, REPLACE(NEWID(), '-', ''))
	

	SessionNo := lastval();
	RETURN QUERY
	SELECT SessionNo, SessionID
	FROM Center_PCSessions
	WHERE SessionNo = SessionNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
