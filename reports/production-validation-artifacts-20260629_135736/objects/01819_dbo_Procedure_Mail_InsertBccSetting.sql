-- ─── PROCEDURE→FUNCTION: mail_insertbccsetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_insertbccsetting(integer, integer);
CREATE OR REPLACE FUNCTION public.mail_insertbccsetting(
    IN userno integer,
    IN bccuserno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Mail_BccSetting(UserNo,BccUserNo)
	values(UserNo,BccUserNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
