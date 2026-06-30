-- ─── FUNCTION: mail_updatemailaccount_name ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemailaccount_name(bigint, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.mail_updatemailaccount_name(
    accountno bigint,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_Accounts SET ModUserNo = mail_updatemailaccount_name.moduserno, ModDate = mail_updatemailaccount_name.moddate, Name = Name
	WHERE AccountNo = mail_updatemailaccount_name.accountno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
