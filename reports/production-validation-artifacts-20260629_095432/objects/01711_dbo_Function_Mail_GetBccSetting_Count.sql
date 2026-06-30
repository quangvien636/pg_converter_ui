-- ─── FUNCTION: mail_getbccsetting_count ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getbccsetting_count();
CREATE OR REPLACE FUNCTION public.mail_getbccsetting_count(
) RETURNS TABLE(
    userno text,
    bccusernocount text
)
AS $function$
BEGIN

	RETURN QUERY
	select UserNo,count(*) as BccUserNoCount from Mail_BccSetting
	group by UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
