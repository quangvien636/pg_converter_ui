-- ─── FUNCTION: mail_insertbccsetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertbccsetting(integer, integer);
CREATE OR REPLACE FUNCTION public.mail_insertbccsetting(
    userno integer,
    bccuserno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Mail_BccSetting(UserNo,BccUserNo)
	values(UserNo,BccUserNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
