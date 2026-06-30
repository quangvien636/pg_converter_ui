-- ─── FUNCTION: approval_updateform ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_updateform(integer, integer, timestamp without time zone, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.approval_updateform(
    formno integer,
    moduserno integer,
    moddate timestamp without time zone,
    name character varying,
    categoryno integer,
    filetype integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Approval_Forms SET
		ModUserNo = approval_updateform.moduserno,
		ModDate = approval_updateform.moddate,
		Name = approval_updateform.name,
		CategoryNo = approval_updateform.categoryno,
		FileType = approval_updateform.filetype,
		Description = Description
	WHERE FormNo = approval_updateform.formno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
