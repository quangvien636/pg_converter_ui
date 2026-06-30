-- ─── FUNCTION: edms_deletedocumenttags ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_deletedocumenttags(bigint);
CREATE OR REPLACE FUNCTION public.edms_deletedocumenttags(
    documentno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM EDMS_DocumentTags
	WHERE DocumentNo = edms_deletedocumenttags.documentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
