-- ─── PROCEDURE→FUNCTION: approval_getform ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.approval_getform(integer);
CREATE OR REPLACE FUNCTION public.approval_getform(
    IN formno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT FormNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, CategoryNo, FileType, Description
	FROM Approval_Forms
	WHERE FormNo = approval_getform.formno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
