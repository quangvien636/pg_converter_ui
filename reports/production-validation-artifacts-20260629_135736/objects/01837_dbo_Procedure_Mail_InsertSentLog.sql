-- ─── PROCEDURE→FUNCTION: mail_insertsentlog ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_insertsentlog(bigint, bigint, character varying, character varying, integer, boolean, boolean, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.mail_insertsentlog(
    IN mailno bigint,
    IN cmsendnum bigint,
    IN name character varying,
    IN address character varying,
    IN senttype integer,
    IN iscomplete boolean,
    IN iscancel boolean,
    IN readdate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    fileno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Mail_SentLogs (MailNo, CMSendNum, Name, Address, SentType, IsComplete, IsCancel, ReadDate)
	VALUES (MailNo, CMSendNum, Name, Address, SentType, IsComplete, IsCancel, ReadDate)


	FileNo := lastval();
	RETURN QUERY
	SELECT FileNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
