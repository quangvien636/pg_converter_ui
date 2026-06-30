-- ─── FUNCTION: mail_updatemailbox_sortno ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemailbox_sortno(bigint, integer);
CREATE OR REPLACE FUNCTION public.mail_updatemailbox_sortno(
    boxno bigint,
    sortno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_MailBoxs SET SortNo = mail_updatemailbox_sortno.sortno, ModDate = NOW()
	WHERE BoxNo = mail_updatemailbox_sortno.boxno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
