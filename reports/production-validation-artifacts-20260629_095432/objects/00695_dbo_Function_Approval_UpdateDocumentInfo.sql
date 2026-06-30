-- ─── FUNCTION: approval_updatedocumentinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_updatedocumentinfo(integer, integer, timestamp without time zone, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.approval_updatedocumentinfo(
    documentno integer,
    reguserno integer,
    regdate timestamp without time zone,
    title character varying,
    state integer,
    currentappno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE ApprovalDocuments SET Title = approval_updatedocumentinfo.title, State = approval_updatedocumentinfo.state,
		CurrentAppNo = approval_updatedocumentinfo.currentappno
	WHERE DocumentNo = approval_updatedocumentinfo.documentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
