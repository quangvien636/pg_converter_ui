-- ─── FUNCTION: fn_userlabel ───────────────────────────────
DROP FUNCTION IF EXISTS public.fn_userlabel(character varying, boolean);
CREATE OR REPLACE FUNCTION public.fn_userlabel(
    name character varying,
    isactive boolean
) RETURNS character varying
AS $function$
BEGIN

    RETURN COALESCE(Name, '') || CASE WHEN IsActive = TRUE THEN ' Active' ELSE ' Inactive' END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role qa_owner not verified.
