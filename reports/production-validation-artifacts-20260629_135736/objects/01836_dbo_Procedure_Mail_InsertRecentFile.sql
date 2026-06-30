-- ─── PROCEDURE→FUNCTION: mail_insertrecentfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_insertrecentfile(integer, bigint, bigint, character varying, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.mail_insertrecentfile(
    IN userno integer,
    IN mailno bigint,
    IN fileno bigint,
    IN name character varying,
    IN size integer,
    IN actiondate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    recentno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	DELETE FROM Mail_RecentMailFiles WHERE FileNo = mail_insertrecentfile.fileno

	INSERT INTO Mail_RecentMailFiles (UserNo, MailNo, FileNo, Name, Size, ActionDate)
	VALUES (UserNo, MailNo, FileNo, Name, Size, ActionDate)
	

	RecentNo := lastval();
	RETURN QUERY
	SELECT RecentNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
