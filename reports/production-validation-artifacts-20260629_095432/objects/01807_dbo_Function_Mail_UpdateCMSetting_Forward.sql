-- ─── FUNCTION: mail_updatecmsetting_forward ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatecmsetting_forward(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.mail_updatecmsetting_forward(
    userno integer,
    popacc character varying,
    domain character varying
) RETURNS void
AS $function$
DECLARE
    mymailaddress character varying;
BEGIN



	SET MyMailAddress = mail_updatecmsetting_forward.popacc || '@' || Domain

	IF (Forward = MyMailAddress) BEGIN
		
		SET Forward = ''

	END

	IF (Forward != '') BEGIN

		IF (STRPOS(Forward, 1, MyMailAddress) = 0) BEGIN

			SET Forward = MyMailAddress || ',' || Forward

		END

	END

	UPDATE Mail_CMSettings SET Forward = Forward
	WHERE UserNo = mail_updatecmsetting_forward.userno AND PopAcc = mail_updatecmsetting_forward.popacc AND Domain = mail_updatecmsetting_forward.domain;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
