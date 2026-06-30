-- ─── PROCEDURE→FUNCTION: mail_updatemailtag_name ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updatemailtag_name(bigint);
CREATE OR REPLACE FUNCTION public.mail_updatemailtag_name(
    IN tagno bigint
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_MailTags SET Name = Name
	WHERE TagNo = mail_updatemailtag_name.tagno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
