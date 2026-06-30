-- ─── FUNCTION: edms_getdocumenttags ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getdocumenttags(bigint);
CREATE OR REPLACE FUNCTION public.edms_getdocumenttags(
    documentno bigint
) RETURNS TABLE(
    tagno text,
    name text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT T.TagNo, T.Name
	FROM EDMS_DocumentTags D
	INNER JOIN EDMS_Tags T ON T.TagNo = D.TagNo
	WHERE D.DocumentNo = edms_getdocumenttags.documentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
