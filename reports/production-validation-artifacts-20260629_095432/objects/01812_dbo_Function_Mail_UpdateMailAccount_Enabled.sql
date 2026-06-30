-- ─── FUNCTION: mail_updatemailaccount_enabled ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemailaccount_enabled(bigint, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatemailaccount_enabled(
    accountno bigint,
    moduserno integer,
    moddate timestamp without time zone,
    enabled boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_Accounts SET ModUserNo = mail_updatemailaccount_enabled.moduserno, ModDate = mail_updatemailaccount_enabled.moddate, Enabled = mail_updatemailaccount_enabled.enabled
	WHERE AccountNo = mail_updatemailaccount_enabled.accountno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
