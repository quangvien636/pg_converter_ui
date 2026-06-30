-- ─── PROCEDURE→FUNCTION: mail_deletebccsetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_deletebccsetting(bigint);
CREATE OR REPLACE FUNCTION public.mail_deletebccsetting(
    IN bccsettingno bigint
) RETURNS void
AS $function$
BEGIN

	DELETE FROM Mail_BccSetting
	WHERE BccSettingNo = mail_deletebccsetting.bccsettingno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
