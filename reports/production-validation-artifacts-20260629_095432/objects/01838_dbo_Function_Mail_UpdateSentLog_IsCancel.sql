-- ─── FUNCTION: mail_updatesentlog_iscancel ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatesentlog_iscancel(bigint, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatesentlog_iscancel(
    logno bigint,
    iscancel boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_SentLogs SET IsCancel = mail_updatesentlog_iscancel.iscancel WHERE LogNo = mail_updatesentlog_iscancel.logno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
