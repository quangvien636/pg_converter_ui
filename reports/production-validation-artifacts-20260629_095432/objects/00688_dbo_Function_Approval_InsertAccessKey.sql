-- ─── FUNCTION: approval_insertaccesskey ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_insertaccesskey(character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.approval_insertaccesskey(
    accesskey character varying,
    userno integer,
    formno integer,
    documentno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO ApprovalAccessKeys(AccessKey, UserNo, RegDate, FormNo, DocumentNo)
	VALUES(AccessKey, UserNo, NOW(), FormNo, DocumentNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
