-- ─── FUNCTION: mail_updatecmsetting_autoyn ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatecmsetting_autoyn(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.mail_updatecmsetting_autoyn(
    userno integer,
    popacc character varying,
    domain character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_CMSettings SET AutoYN = AutoYN
	WHERE UserNo = mail_updatecmsetting_autoyn.userno AND PopAcc = mail_updatecmsetting_autoyn.popacc AND Domain = mail_updatecmsetting_autoyn.domain;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
