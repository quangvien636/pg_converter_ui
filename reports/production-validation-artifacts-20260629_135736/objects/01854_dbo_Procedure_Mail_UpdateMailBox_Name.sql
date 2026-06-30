-- ─── PROCEDURE→FUNCTION: mail_updatemailbox_name ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updatemailbox_name(bigint);
CREATE OR REPLACE FUNCTION public.mail_updatemailbox_name(
    IN boxno bigint
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_MailBoxs SET Name = Name, ModDate = NOW()
	WHERE BoxNo = mail_updatemailbox_name.boxno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
