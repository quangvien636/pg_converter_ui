-- ─── FUNCTION: deletefile ───────────────────────────────
DROP FUNCTION IF EXISTS public.deletefile(integer);
CREATE OR REPLACE FUNCTION public.deletefile(
    fileno integer
) RETURNS void
AS $function$
BEGIN

delete from NoticeSyn_Attachments where AttachNo=deletefile.fileno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
