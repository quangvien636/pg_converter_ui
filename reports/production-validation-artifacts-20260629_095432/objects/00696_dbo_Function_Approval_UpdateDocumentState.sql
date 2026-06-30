-- ─── FUNCTION: approval_updatedocumentstate ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_updatedocumentstate(bigint, integer, bigint);
CREATE OR REPLACE FUNCTION public.approval_updatedocumentstate(
    documentno bigint,
    state integer,
    currentappno bigint
) RETURNS void
AS $function$
BEGIN


	UPDATE Approval_Documents
	SET State = approval_updatedocumentstate.state,
		CurrentAppNo = approval_updatedocumentstate.currentappno
	WHERE DocumentNo = approval_updatedocumentstate.documentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
