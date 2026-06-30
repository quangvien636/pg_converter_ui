-- ─── FUNCTION: notice_deletefile ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_deletefile(bigint);
CREATE OR REPLACE FUNCTION public.notice_deletefile(
    fileno bigint
) RETURNS void
AS $function$
BEGIN

		DELETE FROM NoticeAttachments  WHERE AttachNo = notice_deletefile.fileno;
		--DELETE FROM NoticeAttachments  WHERE NoticeNo = NoticeNo and FileName=FileName
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
