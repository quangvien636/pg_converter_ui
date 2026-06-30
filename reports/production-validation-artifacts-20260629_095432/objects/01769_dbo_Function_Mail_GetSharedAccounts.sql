-- ─── FUNCTION: mail_getsharedaccounts ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getsharedaccounts(integer, integer);
CREATE OR REPLACE FUNCTION public.mail_getsharedaccounts(
    userno integer,
    departno integer
) RETURNS TABLE(
    sharedaccountno text,
    shareduserno text
)
AS $function$
BEGIN



	IF(DepartNo > 0)
	BEGIN
		RETURN QUERY
		SELECT SharedAccountNo, SharedUserNo
		FROM Mail_SharedAccounts
		WHERE UserNo = mail_getsharedaccounts.userno or DepartNo = mail_getsharedaccounts.departno
	END
	ELSE
	BEGIN
		RETURN QUERY
		SELECT SharedAccountNo, SharedUserNo
		FROM Mail_SharedAccounts
		WHERE UserNo = mail_getsharedaccounts.userno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
