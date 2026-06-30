-- ─── FUNCTION: approval_getforminfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_getforminfo(integer);
CREATE OR REPLACE FUNCTION public.approval_getforminfo(
    formno integer
) RETURNS TABLE(
    formno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    name text,
    categoryno text,
    filetype text,
    description text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT FormNo, RegUserNo, RegDate, ModUserNo, ModDate,
		Name, CategoryNo, FileType, Description
	FROM ApprovalForms
	WHERE FormNo = approval_getforminfo.formno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
