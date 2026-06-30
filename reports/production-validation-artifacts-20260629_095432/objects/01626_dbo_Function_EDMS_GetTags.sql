-- ─── FUNCTION: edms_gettags ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_gettags();
CREATE OR REPLACE FUNCTION public.edms_gettags(
) RETURNS TABLE(
    tagno text,
    reguserno text,
    regdate text,
    name text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT TagNo, RegUserNo, RegDate, Name
	FROM EDMS_Tags;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
