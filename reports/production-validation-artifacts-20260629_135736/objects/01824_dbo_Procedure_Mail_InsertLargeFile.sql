-- ─── PROCEDURE→FUNCTION: mail_insertlargefile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_insertlargefile(bigint, character varying, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.mail_insertlargefile(
    IN mailno bigint,
    IN name character varying,
    IN size integer,
    IN expirationdate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    fileno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Mail_MailLargeFiles
	VALUES (MailNo, Name, Size, ExpirationDate)
	

	FileNo := lastval();
	RETURN QUERY
	SELECT FileNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
