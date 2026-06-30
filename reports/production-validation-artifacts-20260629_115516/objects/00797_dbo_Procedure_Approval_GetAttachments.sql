-- ─── PROCEDURE→FUNCTION: approval_getattachments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.approval_getattachments(bigint);
CREATE OR REPLACE FUNCTION public.approval_getattachments(
    IN documentno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT AttachNo, DocumentNo, FileName, FileLength, Description
	FROM Approval_Attachments
	WHERE DocumentNo = approval_getattachments.documentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
