-- ─── PROCEDURE→FUNCTION: mail_insertmailbox ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_insertmailbox(integer, character varying, bigint);
CREATE OR REPLACE FUNCTION public.mail_insertmailbox(
    IN userno integer,
    IN name character varying,
    IN parentno bigint
) RETURNS SETOF record
AS $function$
DECLARE
    boxno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Mail_MailBoxs (UserNo, Name, ParentNo, SortNo, ModDate, TotalCount, UnReadCount, IsShare)
	VALUES(
		UserNo,
		Name,
		ParentNo,
		0,
		NOW(),
		0, 0, 0)
		

	BoxNo := lastval();
	RETURN QUERY
	SELECT BoxNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
