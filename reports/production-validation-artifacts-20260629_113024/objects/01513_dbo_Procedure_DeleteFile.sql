-- ─── PROCEDURE→FUNCTION: deletefile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.deletefile(integer);
CREATE OR REPLACE FUNCTION public.deletefile(
    IN fileno integer
) RETURNS void
AS $function$
BEGIN

delete from NoticeSyn_Attachments where AttachNo=deletefile.fileno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
