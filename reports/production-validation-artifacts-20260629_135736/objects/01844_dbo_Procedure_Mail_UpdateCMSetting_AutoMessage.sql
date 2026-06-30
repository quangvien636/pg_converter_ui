-- ─── PROCEDURE→FUNCTION: mail_updatecmsetting_automessage ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updatecmsetting_automessage(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.mail_updatecmsetting_automessage(
    IN userno integer,
    IN popacc character varying,
    IN domain character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_CMSettings SET AutoMessage = AutoMessage
	WHERE UserNo = mail_updatecmsetting_automessage.userno AND PopAcc = mail_updatecmsetting_automessage.popacc AND Domain = mail_updatecmsetting_automessage.domain;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
