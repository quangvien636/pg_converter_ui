-- ─── PROCEDURE→FUNCTION: mail_updatemail_reservedate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updatemail_reservedate(bigint, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.mail_updatemail_reservedate(
    IN mailno bigint,
    IN reservedate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_Mails SET ReserveDate = mail_updatemail_reservedate.reservedate WHERE MailNo = mail_updatemail_reservedate.mailno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
