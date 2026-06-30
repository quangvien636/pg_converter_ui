-- ─── FUNCTION: mail_updatemailbox_parentno ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemailbox_parentno(bigint, bigint);
CREATE OR REPLACE FUNCTION public.mail_updatemailbox_parentno(
    boxno bigint,
    parentno bigint
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_MailBoxs SET ParentNo = mail_updatemailbox_parentno.parentno, ModDate = NOW()
	WHERE BoxNo = mail_updatemailbox_parentno.boxno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
