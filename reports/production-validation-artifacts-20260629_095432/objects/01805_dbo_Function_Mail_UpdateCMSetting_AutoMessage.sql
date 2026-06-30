-- ─── FUNCTION: mail_updatecmsetting_automessage ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatecmsetting_automessage(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.mail_updatecmsetting_automessage(
    userno integer,
    popacc character varying,
    domain character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_CMSettings SET AutoMessage = AutoMessage
	WHERE UserNo = mail_updatecmsetting_automessage.userno AND PopAcc = mail_updatecmsetting_automessage.popacc AND Domain = mail_updatecmsetting_automessage.domain;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
