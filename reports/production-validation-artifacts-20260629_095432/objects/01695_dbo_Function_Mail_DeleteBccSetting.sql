-- ─── FUNCTION: mail_deletebccsetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_deletebccsetting(bigint);
CREATE OR REPLACE FUNCTION public.mail_deletebccsetting(
    bccsettingno bigint
) RETURNS void
AS $function$
BEGIN

	DELETE FROM Mail_BccSetting
	WHERE BccSettingNo = mail_deletebccsetting.bccsettingno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
