-- ─── PROCEDURE→FUNCTION: approval_insertattachment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.approval_insertattachment(bigint, character varying, integer);
CREATE OR REPLACE FUNCTION public.approval_insertattachment(
    IN documentno bigint,
    IN filename character varying,
    IN filelength integer
) RETURNS SETOF record
AS $function$
DECLARE
    attachno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Approval_Attachments (DocumentNo, FileName, FileLength, Description)
	VALUES(DocumentNo, FileName, FileLength, Description)
	

	AttachNo := lastval();
	RETURN QUERY
	SELECT AttachNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
