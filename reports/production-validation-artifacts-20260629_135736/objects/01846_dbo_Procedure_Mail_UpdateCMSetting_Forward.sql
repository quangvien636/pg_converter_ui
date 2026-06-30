-- ─── PROCEDURE→FUNCTION: mail_updatecmsetting_forward ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updatecmsetting_forward(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.mail_updatecmsetting_forward(
    IN userno integer,
    IN popacc character varying,
    IN domain character varying
) RETURNS void
AS $function$
DECLARE
    mymailaddress character varying;
BEGIN



	MyMailAddress := mail_updatecmsetting_forward.popacc || '@' || Domain;
	IF Forward = MyMailAddress THEN
		
		Forward := '';
	END IF;

	IF Forward != '' THEN

		IF STRPOS(Forward, 1, MyMailAddress) = 0 THEN

			Forward := MyMailAddress || ',' || Forward;
		END IF;

	END IF;

	UPDATE Mail_CMSettings SET Forward = Forward
	WHERE UserNo = mail_updatecmsetting_forward.userno AND PopAcc = mail_updatecmsetting_forward.popacc AND Domain = mail_updatecmsetting_forward.domain;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
