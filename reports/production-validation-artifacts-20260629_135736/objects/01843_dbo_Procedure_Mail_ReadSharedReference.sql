-- ─── PROCEDURE→FUNCTION: mail_readsharedreference ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_readsharedreference(bigint, integer);
CREATE OR REPLACE FUNCTION public.mail_readsharedreference(
    IN mailno bigint,
    IN userno integer
) RETURNS void
AS $function$
DECLARE
    referenceno integer;
BEGIN



	ReferenceNo := (SELECT ReferenceNo FROM Mail_SharedReference WHERE MailNo = mail_readsharedreference.mailno and UserNo = mail_readsharedreference.userno);
	IF ReferenceNo IS NULL THEN;
		INSERT INTO Mail_SharedReference(MailNo,UserNo,ReadDate,ModDate) values(MailNo,UserNo,NOW(),NOW())
	END IF;
	ELSE;
		update Mail_SharedReference
		ModDate := NOW();
		WHERE MailNo = mail_readsharedreference.mailno and UserNo = mail_readsharedreference.userno
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
