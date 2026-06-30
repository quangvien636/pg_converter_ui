-- ─── PROCEDURE→FUNCTION: mail_insertfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_insertfile(bigint, character varying, integer);
CREATE OR REPLACE FUNCTION public.mail_insertfile(
    IN mailno bigint,
    IN name character varying,
    IN size integer
) RETURNS SETOF record
AS $function$
DECLARE
    fileno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Mail_MailFiles
	VALUES (MailNo, Name, Size)
	

	FileNo := lastval();
	RETURN QUERY
	SELECT FileNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
