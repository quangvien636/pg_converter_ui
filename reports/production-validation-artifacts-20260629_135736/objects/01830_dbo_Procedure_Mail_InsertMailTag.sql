-- ─── PROCEDURE→FUNCTION: mail_insertmailtag ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_insertmailtag(integer, integer);
CREATE OR REPLACE FUNCTION public.mail_insertmailtag(
    IN userno integer,
    IN imageno integer
) RETURNS SETOF record
AS $function$
DECLARE
    tagno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Mail_MailTags (UserNo, ImageNo, Name, TotalCount, UnReadCount)
	VALUES (UserNo, ImageNo, Name, 0, 0)
	

	TagNo := lastval();
	RETURN QUERY
	SELECT TagNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
