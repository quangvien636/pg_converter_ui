-- ─── FUNCTION: mail_readsharedreference ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_readsharedreference(bigint, integer);
CREATE OR REPLACE FUNCTION public.mail_readsharedreference(
    mailno bigint,
    userno integer
) RETURNS void
AS $function$
DECLARE
    referenceno integer;
BEGIN



	SET ReferenceNo = (SELECT ReferenceNo FROM Mail_SharedReference WHERE MailNo = mail_readsharedreference.mailno and UserNo = mail_readsharedreference.userno)
	IF (ReferenceNo IS NULL) BEGIN;
		INSERT INTO Mail_SharedReference(MailNo,UserNo,ReadDate,ModDate) values(MailNo,UserNo,NOW(),NOW())
	END
	ELSE
	BEGIN;
		update Mail_SharedReference
		set ModDate = NOW()
		WHERE MailNo = mail_readsharedreference.mailno and UserNo = mail_readsharedreference.userno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
