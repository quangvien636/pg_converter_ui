-- ─── PROCEDURE→FUNCTION: integrated_insertfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.integrated_insertfile(bigint, character varying, integer);
CREATE OR REPLACE FUNCTION public.integrated_insertfile(
    IN contentno bigint,
    IN name character varying,
    IN size integer
) RETURNS SETOF record
AS $function$
DECLARE
    fileno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Integrated_Files (ContentNo, Name, Size)
	VALUES (ContentNo, Name, Size)
	

	FileNo := lastval();
	RETURN QUERY
	SELECT FileNo

END;

--------------------------------/////////////////////-------------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
